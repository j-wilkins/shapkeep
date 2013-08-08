require 'spec_helper'

describe Shapkeep do
  let(:redis) { Redis.new }
  subject { Shapkeep.new('spec/fixtures/store.yml') }

  context 'script store' do
    specify { expect(subject.script_store.keys).to eq([:zero, :one, :file]) }
  end

  context 'script available' do
    specify { expect(subject.script_available?(:nope)).to be_false }
    specify { expect(subject.script_available?(:zero)).to be_true }
  end

  describe 'load scripts' do
    before { redis.script(:flush); subject.load_scripts!(redis) }
    specify do
      expect(redis.script(:exists, [subject.send(:sha_for_script_name, :zero),
        subject.send(:sha_for_script_name, :one)])).to be_true
    end
  end

  describe 'eval' do
    context 'invalid script name' do
      specify do
        expect(Proc.new { subject.eval(nil, :nope) }).to(
          raise_error(Shapkeep::InvalidScriptNameError))
      end
    end

    context 'script not loaded' do
      before { redis.script(:flush) }
      specify { expect(subject.eval(redis, :zero)).to eq(0) }
    end

    context 'script loaded' do
      before do
        redis.script(:load, subject.script_store[:one][:script])
        def subject.load_script(*args)
          raise 'Tried to Load a script #wtf!'
        end
      end
      specify do
        expect(subject.eval(redis, :one)).to be(1)
      end
    end

    context 'script is filename' do
      before { redis.script(:flush) }
      specify { expect(subject.eval(redis, :file)).to eq(2) }
    end

    context 'script errors' do
      subject { Shapkeep.new('spec/fixtures/store_error.yml') }
      specify do
        expect(Proc.new { subject.eval(redis, :error) }).to(
          raise_error(Redis::CommandError))
      end
    end
  end
end
