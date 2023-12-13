# frozen_string_literal: true

# バイナリの書き換えのみをする
class ProconBypassMan::Domains::ProcessingProconBinary < ProconBypassMan::Domains::Binary::Base
  include ProconBypassMan::Domains::HasMutableBinary

  ALL_ZERO_BIT = ["0"].pack("H*").freeze

  def set_no_action!
    binary[3] = ALL_ZERO_BIT
    binary[4] = ALL_ZERO_BIT
    binary[5] = ALL_ZERO_BIT
  end

  # @param [ProconBypassMan::Domains::ProcessingProconBinary]
  # @return [ProconBypassMan::Domains::ProcessingProconBinary]
  # アナログスティックは上書きし、ボタンだけマージする
  def write_as_merge!(target_binary)
    current_buttons = ProconBypassMan::ProconReader.new(binary: binary).pressing
    target_buttons = ProconBypassMan::ProconReader.new(binary: target_binary.raw).pressing

    set_no_action!
    (current_buttons + target_buttons).uniq.each do |button|
      write_as_press_button(button)
    end

    # override analog stick
    tb = [target_binary.raw].pack("H*")
    binary[6] = tb[6]
    binary[7] = tb[7]
    binary[8] = tb[8]
    binary[9] = tb[9]
    binary[10] = tb[10]
    binary[11] = tb[11]

    self
  end

  # @param [Symbol] button
  def write_as_press_button(button)
    return if ProconBypassMan::PressButtonAware.new(binary).pressing_button?(button)

    button_obj = ProconBypassMan::Procon::Button.new(button)
    value = binary[button_obj.byte_position].unpack("C").first + (2**button_obj.bit_position)
    binary[button_obj.byte_position] = ["%02X" % value.to_s].pack("H*")
  end

  # @param [Symbol] stick method
  def write_as_tilt_left_stick(step)
    binary[6..8] = ProconBypassMan::Procon::AnalogStickManipulator.new(binary, method: step).to_binary
  end

  # @param [Symbol] button
  def write_as_unpress_button(button)
    raise "do not press button(#{button}) yet" if not ProconBypassMan::PressButtonAware.new(binary).pressing_button?(button)

    button_obj = ProconBypassMan::Procon::Button.new(button)
    value = binary[button_obj.byte_position].unpack("C").first - (2**button_obj.bit_position)
    binary[button_obj.byte_position] = ["%02X" % value.to_s].pack("H*")
  end

  # @param [Symbol] button
  def write_as_press_button_only(button)
    set_no_action!
    write_as_press_button(button)
  end

  # @param [Integer] cap
  def write_as_apply_left_analog_stick_cap(cap: )
    analog_stick_cap = ProconBypassMan::Procon::AnalogStickCap.new(binary)
    binary[6..8] = analog_stick_cap.capped_position(cap_hypotenuse: cap).to_binary
  end

  def write_as_apply_gyro(gyro: )
    binary[13..24] = gyro
  end
end
