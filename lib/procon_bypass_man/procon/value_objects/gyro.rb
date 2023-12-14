# frozen_string_literal: true

class ProconBypassMan::Procon::Gyro
  
    def initialize(binary: )
        bytes13 = binary[13].unpack("C")
        bytes14 = binary[14].unpack("C")
        bytes15 = binary[15].unpack("C")
        bytes16 = binary[16].unpack("C")
        bytes17 = binary[17].unpack("C")
        bytes18 = binary[18].unpack("C")
        bytes19 = binary[19].unpack("C")
        bytes20 = binary[20].unpack("C")
        bytes21 = binary[21].unpack("C")
        bytes22 = binary[22].unpack("C")
        bytes23 = binary[23].unpack("C")
        bytes24 = binary[24].unpack("C")
        # bytes13 = binary[13] >> 0 & ((1 << 8) - 1)
        # bytes14 = binary[14] >> 0 & ((1 << 8) - 1)
        # uint16le = (bytes14 << 8) | bytes13
        # int16le = uint16le
        # if uint16le >= 32768
        #     int16le = uint16le - 65536
        # ProconBypassMan.logger.debug {"[gyro.rb] int16le:#{int16le}"}
        ProconBypassMan.logger.debug {"[gyro.rb] int16le:#{bytes13}, #{bytes14},#{bytes15}, #{bytes16},#{bytes17}, #{bytes18},#{bytes19}, #{bytes20},#{bytes21}, #{bytes22},#{bytes23}, #{bytes24}"}
        freeze
    end
  

  end
  