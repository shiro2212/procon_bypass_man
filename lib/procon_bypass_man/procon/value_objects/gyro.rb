# frozen_string_literal: true

class ProconBypassMan::Procon::Gyro
    attr_accessor :accel_x, :accel_y, :accel_z, :gyro_1, :gyro_2, :gyro_3
  
    def initialize(binary: )
        @accel_x = binary[13..14].unpack("S")
        @accel_y = binary[15..16].unpack("S")
        @accel_z = binary[17..18].unpack("S")
        @gyro_1 = binary[19..20].unpack("S")
        @gyro_2 = binary[21..22].unpack("S")
        @gyro_3 = binary[23..24].unpack("S")
        ## accel_x:[64821], accel_y:[5], accel_z:[4081],, gyro_1:[65524], gyro_2:[65529], gyro_3:[5]
        # ProconBypassMan.logger.debug {"[gyro.rb] accel_x:#{accel_x}, accel_y:#{accel_y}, accel_z:#{accel_z},, gyro_1:#{gyro_1}, gyro_2:#{gyro_2}, gyro_3:#{gyro_3}"}
        freeze
    end
    
    def gyro_list
        [accel_x, accel_y, accel_z, gyro_1, gyro_2, gyro_3]
    end

end
  