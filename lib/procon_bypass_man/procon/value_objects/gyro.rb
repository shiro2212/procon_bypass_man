# frozen_string_literal: true

class ProconBypassMan::Procon::Gyro
  
    def initialize(binary: )
        bytes13ss = binary[13].unpack("S")
        bytes14ss = binary[14].unpack("S")
        bytes13i = binary[13].unpack("I")
        bytes14i = binary[14].unpack("I")
        # bytes13 = binary[13] & ((1 << 8) - 1)
        # bytes14 = binary[14] & ((1 << 8) - 1)
        # uint16le = (bytes14 << 8) | bytes13
        # int16le = uint16le
        # if uint16le >= 32768
        #     int16le = uint16le - 65536
        # ProconBypassMan.logger.debug {"[gyro.rb] int16le:#{int16le}"}
        ProconBypassMan.logger.debug {"[gyro.rb] int16le:#{binary[13]}, #{binary[14]},#{bytes13ss}, #{bytes14ss},#{bytes13i}, #{bytes14i}"}
        freeze
    end
  

  end
  