require 'delegate'
require 'shapkeep'

class Shapkeep
  class Wrapper < SimpleDelegator

    attr_reader :shapkeep

    def initialize(script_file, redis)
      super(redis)
      @shapkeep = Shapkeep.new(script_file)
    end

    def eval_script(script_name, keys = [], args = [])
      shapkeep.eval(redis, script_name, keys, args)
    end

    def redis
      __getobj__
    end
  end
end
