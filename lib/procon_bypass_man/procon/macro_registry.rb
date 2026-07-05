# frozen_string_literal: true

class ProconBypassMan::Procon::MacroRegistry
  PRESETS = {
    null: [],
  }

  def self.install_plugin(klass, steps: nil, macro_type: :normal)
    if plugins.fetch([klass.to_s.to_sym, macro_type], nil)
      Kernel.warn "#{klass} macro is already registered"
      return
    end

    source_steps = steps || klass.steps
    dynamic_ikarole_macro_names[[klass.to_s.to_sym, macro_type]] = source_steps.any? { |step| step.to_s =~ /\Adynamic_ikarole/ }
    plugins.store(
      [klass.to_s.to_sym, macro_type], ->(context: {}){
        ProconBypassMan::Procon::MacroBuilder.new(source_steps, context: context).build
      }
    )
  end

  # @return [ProconBypassMan::Procon::Macro]
  def self.load(name, macro_type: :normal, force_neutral_buttons: [], context: {}, &after_callback_block)
    if(steps = PRESETS[name] || plugins.fetch([name.to_s.to_sym, macro_type], nil)&.call(context: context))
      return ProconBypassMan::Procon::Macro.new(name: name, steps: steps.dup, force_neutral_buttons: force_neutral_buttons, &after_callback_block)
    else
      warn "installされていないマクロ(#{name})を使うことはできません"
      return self.load(:null)
    end
  end

  def self.dynamic_ikarole?(name, macro_type: :normal)
    !!dynamic_ikarole_macro_names[[name.to_s.to_sym, macro_type]]
  end

  def self.dynamic_ikarole_macro_names
    @dynamic_ikarole_macro_names ||= {}
  end

  def self.reset!
    @dynamic_ikarole_macro_names = {}
    ProconBypassMan::ButtonsSettingConfiguration.instance.macro_plugins = ProconBypassMan::Procon::MacroPluginMap.new
  end

  def self.plugins
    ProconBypassMan::ButtonsSettingConfiguration.instance.macro_plugins
  end

  def self.cleanup_remote_macros!
    remote_keys = ProconBypassMan::Procon::MacroRegistry.plugins.original_keys.select { |_, y| y == :remote }
    remote_keys.each do |remote_key|
      ProconBypassMan::Procon::MacroRegistry.plugins.delete(remote_key)
      dynamic_ikarole_macro_names.delete(remote_key)
    end
    ProconBypassMan::Procon::MacroRegistry.plugins
  end

  reset!
end
