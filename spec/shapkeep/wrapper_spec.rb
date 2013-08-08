require 'spec_helper'

describe Shapkeep::Wrapper do
  let(:redis) { Redis.new }
  subject { Shapkeep::Wrapper.new('spec/fixtures/store.yml', redis) }

  describe 'shapkeep' do
    specify { expect(subject.shapkeep).to be_instance_of(Shapkeep) }
  end

  describe 'eval' do
    it 'gets ours not Kernels' do
      expect(subject.eval('return {1,2,3}')).to eq([1,2,3])
    end

    context 'with redis namespace' do
      let(:rn) { Redis::Namespace.new(:test, redis: redis) }
      subject { Shapkeep::Wrapper.new('spec/fixtures/store.yml', rn) }

      specify { expect(subject.eval('return {1,2,3}')).to eq([1,2,3]) }
    end
  end

  describe 'eval_script' do
    specify { expect(subject.respond_to?(:eval_script)).to be_true }
    specify { expect(subject.eval_script(:zero)).to be(0) }
    specify { expect(subject.eval_script(:one)).to be(1) }
  end

  describe 'delegating to redis' do
    specify { expect(subject.keys).to be_instance_of(Array) }
    specify { expect(subject.set('asdf', 'yupyupyup')).to eq('OK') }
    specify { expect(subject.del('asdf')).to be_instance_of(Fixnum) }
  end
end
