# frozen_string_literal: true

class ProconBypassMan::Procon::AnalogStickManipulator
  attr_accessor :manipulated_abs_x, :manipulated_abs_y

  def initialize(binary, method: )
    analog_stick = ProconBypassMan::Procon::AnalogStick.new(
      binary: binary,
      byte_position: byte_position(method),
    )

    if method =~ /tilt_(left|right)_stick_(completely)_to_(left|right|up|down)/
      direction = $3
      neutral_position = ProconBypassMan::ButtonsSettingConfiguration.instance.neutral_position
      syahen = 1800 # 最大まで傾けた状態

      case direction
      when 'left'
        self.manipulated_abs_x = neutral_position.x - syahen
        self.manipulated_abs_y = neutral_position.y
      when 'right'
        self.manipulated_abs_x = neutral_position.x + syahen
        self.manipulated_abs_y = neutral_position.y
      when 'up'
        self.manipulated_abs_x = analog_stick.abs_x
        self.manipulated_abs_y = 3400
      when 'down'
        self.manipulated_abs_x = analog_stick.abs_x
        self.manipulated_abs_y = 400
      end

      return
    end

    if method =~ /tilt_left_stick_(completely)_to_(\d+)deg/
      arc_degree = $2.to_i
      syahen = 1800 # 最大まで傾けた状態
      neutral_position = ProconBypassMan::ButtonsSettingConfiguration.instance.neutral_position
      self.manipulated_abs_x = neutral_position.x + (syahen * Math.cos(arc_degree * Math::PI / 180)).to_i
      self.manipulated_abs_y = neutral_position.y + (syahen * Math.sin(arc_degree * Math::PI / 180)).to_i
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

  private

  def byte_position(method)
    if method =~ /tilt_right_stick_/
      ProconBypassMan::Procon::ButtonCollection::RIGHT_ANALOG_STICK.fetch(:byte_position)
    else
      ProconBypassMan::Procon::ButtonCollection::LEFT_ANALOG_STICK.fetch(:byte_position)
    end
  end
end
