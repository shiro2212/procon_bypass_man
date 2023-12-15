# frozen_string_literal: true

class ProconBypassMan::Procon::Gyro
    attr_accessor :accel_x, :accel_y, :accel_z, :gyro_1, :gyro_2, :gyro_3
  
    def initialize(binary: )
        bin_accel_x = binary[13..14].unpack("S<").first
        bin_accel_y = binary[15..16].unpack("S<").first
        bin_accel_z = binary[17..18].unpack("S<").first
        @accel_x = bin_accel_x < 32768 ? bin_accel_x : bin_accel_x - 65536
        @accel_y = bin_accel_y < 32768 ? bin_accel_y : bin_accel_y - 65536
        @accel_z = bin_accel_z < 32768 ? bin_accel_z : bin_accel_z - 65536

        bin_gyro_1 = binary[19..20].unpack("S<").first
        bin_gyro_2 = binary[21..22].unpack("S<").first
        bin_gyro_3 = binary[23..24].unpack("S<").first
        @gyro_1 = bin_gyro_1 < 32768 ? bin_gyro_1 : bin_gyro_1 - 65536
        @gyro_2 = bin_gyro_2 < 32768 ? bin_gyro_2 : bin_gyro_2 - 65536
        @gyro_3 = bin_gyro_3 < 32768 ? bin_gyro_3 : bin_gyro_3 - 65536
        # S< # [gyro.rb] accel_x:[64781], accel_y:[65514], accel_z:[4076],, gyro_1:[65525], gyro_2:[65525], gyro_3:[3]
        # int# [gyro.rb] accel_x:-752, accel_y:-22, accel_z:4073,, gyro_1:-11, gyro_2:-9, gyro_3:3
        # ProconBypassMan.logger.debug {"[gyro.rb] accel_x:#{accel_x}, accel_y:#{accel_y}, accel_z:#{accel_z},, gyro_1:#{gyro_1}, gyro_2:#{gyro_2}, gyro_3:#{gyro_3}"}
        freeze
    end
    
    def gyro_list
        [accel_x, accel_y, accel_z, gyro_1, gyro_2, gyro_3]
    end

end
  