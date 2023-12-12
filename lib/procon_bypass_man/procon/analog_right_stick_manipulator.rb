# frozen_string_literal: true

class ProconBypassMan::Procon::AnalogRightStickManipulator
  attr_accessor :manipulated_abs_x, :manipulated_abs_y

  def initialize(binary, method: )
    ProconBypassMan.logger.debug "[AnalogRightStickManipulator] initialize"
    analog_stick = ProconBypassMan::Procon::AnalogRightStick.new(binary: binary)

    if method =~ /tilt_right_stick_(completely)_to_(\d+)deg/
      power_level = $1
      arc_degree = $2.to_i
      syahen = 1800 # 最大まで傾けた状態
      neutral_position = ProconBypassMan::ButtonsSettingConfiguration.instance.neutral_position
      self.manipulated_abs_x = (syahen * Math.cos(arc_degree * Math::PI / 180)).to_i - neutral_position.x
      self.manipulated_abs_y = (syahen * Math.sin(arc_degree * Math::PI / 180)).to_i - neutral_position.y
      ProconBypassMan.logger.debug "[AnalogRightStickManipulator] #{self.manipulated_abs_x}, #{self.manipulated_abs_y}"
      return
    end

    warn "error stick manipulator"
    self.manipulated_abs_x = analog_stick.abs_x
    self.manipulated_abs_y = analog_stick.abs_y
  end


  # @return [String]
  def to_binary
    ProconBypassMan::AnalogStickPosition.new(
      x: self.manipulated_abs_x,
      y: self.manipulated_abs_y,
    ).to_binary
  end
end
