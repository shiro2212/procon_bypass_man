# frozen_string_literal: true

class ProconBypassMan::Procon::Gyro
  
    def initialize(binary: )
        bytes13 = binary[13].unpack("C")
        bytes14 = binary[14].unpack("C")
        accel_x = (bytes14 << 8) | bytes13
        bytes15 = binary[15].unpack("C")
        bytes16 = binary[16].unpack("C")
        accel_y = (bytes16 << 8) | bytes15
        bytes17 = binary[17].unpack("C")
        bytes18 = binary[18].unpack("C")
        accel_z = (bytes18 << 8) | bytes17
        bytes19 = binary[19].unpack("C")
        bytes20 = binary[20].unpack("C")
        gyro_1 = (bytes16 << 8) | bytes15
        
        bytes21 = binary[21].unpack("C")
        bytes22 = binary[22].unpack("C")
        gyro_2 = (bytes22 << 8) | bytes21
        
        bytes23 = binary[23].unpack("C")
        bytes24 = binary[24].unpack("C")
        gyro_3 = (bytes24 << 8) | bytes23
        # bytes13 = binary[13] >> 0 & ((1 << 8) - 1)
        # bytes14 = binary[14] >> 0 & ((1 << 8) - 1)
        # uint16le = (bytes14 << 8) | bytes13
        # int16le = uint16le
        # if uint16le >= 32768
        #     int16le = uint16le - 65536
        # ProconBypassMan.logger.debug {"[gyro.rb] int16le:#{int16le}"}
        ProconBypassMan.logger.debug {"[gyro.rb] accel_x:#{accel_x}, accel_y:#{accel_y}, accel_z:#{accel_z},, gyro_1:#{gyro_1}, gyro_2:#{gyro_2}, gyro_3:#{gyro_3}"}

        freeze
    end
  

  end
  