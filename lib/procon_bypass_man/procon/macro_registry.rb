class ProconBypassMan::Procon::MacroRegistry
  class Macro
    attr_accessor :name, :steps

    def initialize(name: , steps: )
      self.name = name
      self.steps = steps
    end

    def next_step
      steps.shift
    end

    def finished?
      steps.empty?
    end

    def ongoing?
      !finished?
    end
  end

  PRESETS = {
    null: [],
  }

  def self.install_plugin(klass)
    if plugins[klass.name]
      raise "#{klass.name} macro is already registered"
    end
    plugins[klass.name] = klass.steps
  end

  def self.load(name)
    steps = PRESETS[name] || plugins[name] || raise("unknown macro")
    Macro.new(name: name, steps: steps.dup)
  end

  def self.reset!
    ProconBypassMan::ButtonsSettingConfiguration.instance.macro_plugins = {}
  end

  def self.plugins
    ProconBypassMan::ButtonsSettingConfiguration.instance.macro_plugins
  end

  reset!
end
