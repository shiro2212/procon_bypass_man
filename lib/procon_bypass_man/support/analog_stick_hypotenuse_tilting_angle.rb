class ProconBypassMan::AnalogStickTiltingAngle

  # @return [Boolean]
  def widthinAngleRange?(current_position_x: , current_position_y: , degreeFrom: -360, degreeTo: 360)
    # スティックがニュートラルな時
    if (-200..200).include?(current_position_x) && (-200..200).include?(current_position_y)
      return false
    end

    degree = getDegree(current_position_x:current_position_x , current_position_y:current_position_y)
    return degreeFrom <= degree && degree <= degreeTo
  end

  def getDegree(current_position_x: , current_position_y:)
    return Math::atan2(current_position_y, current_position_x)/Math::PI * 180
  end
end
