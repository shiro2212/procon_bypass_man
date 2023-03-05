require "spec_helper"

describe ProconBypassMan::RemoteAction::TaskQueue do
  let(:queue) { described_class.new }

  describe '.non_blocking_shift' do
    subject { queue.non_blocking_shift }

    context 'when blank' do
      it do
        expect(subject).to eq(false)
      end
    end

    context 'when has a task' do
      before do
        queue.push(1)
      end

      it do
        expect(subject).to eq(1)
      end
    end
  end

  describe '.present?' do
    subject { queue.present? }

    context 'when blank' do
      it do
        expect(subject).to eq(false)
      end
    end

    context 'when has a task' do
      before do
        queue.push(1)
      end

      it do
        expect(subject).to eq(true)
      end
    end
  end
end
