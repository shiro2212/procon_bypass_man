# frozen_string_literal: true

class ProconBypassMan::Procon::Gyro
    attr_accessor :accel_x, :accel_y, :accel_z, :gyro_1, :gyro_2, :gyro_3
  
    def initialize(binary: )
        @accel_x = binary[13..14].unpack("S<").first < 32768 ? binary[13..14].unpack("S<").first : binary[13..14].unpack("S<").first - 65536
        @accel_y = binary[15..16].unpack("S<").first < 32768 ? binary[15..16].unpack("S<").first : binary[15..16].unpack("S<").first - 65536
        @accel_z = binary[17..18].unpack("S<").first < 32768 ? binary[17..18].unpack("S<").first : binary[17..18].unpack("S<").first - 65536
        @gyro_1 = binary[19..20].unpack("S<").first < 32768 ? binary[19..20].unpack("S<").first : binary[19..20].unpack("S<").first - 65536
        @gyro_2 = binary[21..22].unpack("S<").first < 32768 ? binary[21..22].unpack("S<").first : binary[21..22].unpack("S<").first - 65536
        @gyro_3 = binary[23..24].unpack("S<").first < 32768 ? binary[23..24].unpack("S<").first : binary[23..24].unpack("S<").first - 65536
        # S< # [gyro.rb] accel_x:[64781], accel_y:[65514], accel_z:[4076],, gyro_1:[65525], gyro_2:[65525], gyro_3:[3]
        # S> # [gyro.rb] accel_x:[3581], accel_y:[60415], accel_z:[59919],, gyro_1:[62719], gyro_2:[63487], gyro_3:[512]
        # S* # [gyro.rb] accel_x:[64780], accel_y:[65521], accel_z:[4088],, gyro_1:[65524], gyro_2:[65528], gyro_3:[4]
        ProconBypassMan.logger.debug {"[gyro.rb] accel_x:#{accel_x}, accel_y:#{accel_y}, accel_z:#{accel_z},, gyro_1:#{gyro_1}, gyro_2:#{gyro_2}, gyro_3:#{gyro_3}"}
        ProconBypassMan.logger.debug {"[gyro.rb] uint16 #{[uint16]}"}
        freeze
    end
    
    def gyro_list
        [accel_x, accel_y, accel_z, gyro_1, gyro_2, gyro_3]
    end

end
  