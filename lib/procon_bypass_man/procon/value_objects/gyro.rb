# frozen_string_literal: true

class ProconBypassMan::Procon::Gyro
  
    def initialize(binary: )
        ProconBypassMan.logger.debug {"[gyro.rb] byte13..14:#{binary}"}
    #   bytes = binary[13..14]
    #   byte13, byte14 = bytes.each_char.map { |x| x.unpack("I").first.to_s(2).rjust(8, "0") }
    #   ProconBypassMan.logger.debug {"[gyro.rb] byte13..14:#{byte13}, #{byte14}"}
        freeze
    end
  

  end
  