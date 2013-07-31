require 'redis'
require 'shapkeep/version'

class Shapkeep
  InvalidScriptNameError = Class.new(StandardError)

  attr_reader :sha_file

  def initialize(sha_file)
    @sha_file = sha_file
  end

  def eval(redis, name, keys = [], args = [])
    begin
      invalid_script_name!(name) unless script_available?(name)
      redis.evalsha(sha_for_script(name), keys, args)
    rescue Redis::CommandError => boom
      raise boom unless boom.message.include?('NOSCRIPT')

      load_script(redis, name)
      retry
    end
  end

  def load_scripts!(redis)
    script_store.keys.each { |name| load_script(redis, name) }
  end

  def script_store
    @script_store ||= YAML.load_file(sha_file)
  end

  def script_available?(name)
    script_store.has_key?(name)
  end

  private

  def sha_for_script(name)
    script_store[name.to_sym][:sha] ||= sha_script(name)
  end

  def sha_script(name)
    Digest::SHA1.hexdigest(script_for_name(name))
  end

  def script_for_name(name)
    script_store[name.to_sym][:script]
  end

  def load_script(redis, name)
    sha = redis.script(:load, script_for_name(name))
    script_store[name][:sha] = sha
  end

  def invalid_script_name!(name)
    raise InvalidScriptNameError.new("No script with name [ #{name} ].")
  end

end
