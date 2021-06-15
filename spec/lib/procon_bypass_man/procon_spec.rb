require "spec_helper"

describe ProconBypassMan::Procon do
  let(:binary) { [data].pack("H*") }

  context 'プラグインなし' do
    before do
      ProconBypassMan.configure do
        prefix_keys_for_changing_layer [:zr, :r, :zl, :l]
        layer :up do
          flip :down, if_pushed: true
          flip :zr, if_pushed: true
          flip :a
          flip :zl, if_pushed: [:y, :b]
        end
        layer :right, mode: :auto
        layer :left do
        end
        layer :down do
          flip :zl, if_pushed: true
        end
      end
    end

    describe '#pushed_zr?' do
      subject { ProconBypassMan::Procon.new(binary).pushed_zr? }
      context 'zr押している' do
        let(:data) { "3012818a8000b0377246f8750988f5c70bfb011400e9ff180083f5d00bf9011100ecff190088f5d10bf9011000f1ff1c00000000000000000000000000000000" }
        it { expect(subject).to eq(true) }
      end
      context 'zr押していない' do
        let(:data) { "30f28100800078c77448287509550274ff131029001b0022005a0271ff191028001e00210064027cff1410280020002100000000000000000000000000000000" }
        it { expect(subject).to eq(false) }
      end
    end

    describe '#pushed_down?' do
      subject { ProconBypassMan::Procon.new(binary).pushed_down? }
      context 'zr押していない' do
        let(:data) { "30f28100800078c77448287509550274ff131029001b0022005a0271ff191028001e00210064027cff1410280020002100000000000000000000000000000000" }
        it { expect(subject).to eq(false) }
      end
      context 'zr押している' do
        let(:data) { "3012818a8000b0377246f8750988f5c70bfb011400e9ff180083f5d00bf9011100ecff190088f5d10bf9011000f1ff1c00000000000000000000000000000000" }
        it { expect(subject).to eq(false) }
      end
    end

    describe 'ZRを押しっぱなしのときは出力をトグルすること' do
      context 'zr押している' do
        let(:data) { "3012818a8000b0377246f8750988f5c70bfb011400e9ff180083f5d00bf9011100ecff190088f5d10bf9011000f1ff1c00000000000000000000000000000000".freeze }
        it do
          procon = ProconBypassMan::Procon.new(binary)
          procon.apply!
          expect(procon.pushed_zr?).to eq(true)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_zr?).to eq(true)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_down?).to eq(false)

          procon = ProconBypassMan::Procon.new(binary)
          procon.apply!
          expect(procon.pushed_zr?).to eq(true)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_zr?).to eq(false)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_down?).to eq(false)

          procon = ProconBypassMan::Procon.new(binary)
          procon.apply!
          expect(procon.pushed_zr?).to eq(true)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_zr?).to eq(true)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_down?).to eq(false)
        end
      end
      context 'a, zr押していない' do
        let(:data) { "30f28100800078c77448287509550274ff131029001b0022005a0271ff191028001e00210064027cff1410280020002100000000000000000000000000000000" }
        it do
          procon = ProconBypassMan::Procon.new(binary)
          procon.apply!
          expect(procon.pushed_zr?).to eq(false)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_zr?).to eq(false)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_down?).to eq(false)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_a?).to eq(false)

          procon = ProconBypassMan::Procon.new(binary)
          procon.apply!
          expect(procon.pushed_zr?).to eq(false)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_zr?).to eq(false)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_down?).to eq(false)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_a?).to eq(true)

          procon = ProconBypassMan::Procon.new(binary)
          procon.apply!
          expect(procon.pushed_zr?).to eq(false)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_zr?).to eq(false)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_down?).to eq(false)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_a?).to eq(false)
        end
      end
      context 'zr押していない' do
        let(:data) { "30f28100800078c77448287509550274ff131029001b0022005a0271ff191028001e00210064027cff1410280020002100000000000000000000000000000000" }
        it do
          procon = ProconBypassMan::Procon.new(binary)
          procon.apply!
          expect(procon.pushed_zr?).to eq(false)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_zr?).to eq(false)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_down?).to eq(false)

          procon = ProconBypassMan::Procon.new(binary)
          procon.apply!
          expect(procon.pushed_zr?).to eq(false)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_zr?).to eq(false)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_down?).to eq(false)

          procon = ProconBypassMan::Procon.new(binary)
          procon.apply!
          expect(procon.pushed_zr?).to eq(false)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_zr?).to eq(false)
          expect(ProconBypassMan::Procon.new(procon.to_binary).pushed_down?).to eq(false)
        end
      end
    end
  end
end
