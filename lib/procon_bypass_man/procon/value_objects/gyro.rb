# frozen_string_literal: true

class ProconBypassMan::Procon::Gyro
  
    def initialize(binary: )
        # bytes13 = binary[13] & ((1 << 8) - 1)
        # bytes14 = binary[14] & ((1 << 8) - 1)
        # uint16le = (bytes14 << 8) | bytes13
        # int16le = uint16le
        # if uint16le >= 32768
        #     int16le = uint16le - 65536
        # ProconBypassMan.logger.debug {"[gyro.rb] int16le:#{int16le}"}
        ProconBypassMan.logger.debug {"[gyro.rb] int16le:"}
        freeze
    end
  

  end
  