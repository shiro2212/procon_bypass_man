class ProconBypassMan::Processor
  # @return [String] binary
  def initialize(binary)
    @binary = binary
  end

  # @return [String] 加工後の入力データ
  def process
    unless @binary[0] == "\x30".b
      return @binary
    end

    procon = ProconBypassMan::Procon.new(@binary)
    procon.apply!
    procon.to_binary
  end
end
