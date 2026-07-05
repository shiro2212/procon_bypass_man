# frozen_string_literal: true

class ProconBypassMan::Procon::MacroBuilder
  class SubjectMerger
    def self.merge(subjects)
      if subjects.size == 1
        return subjects.first.to_steps
      end

      subjects.inject([[], []]) do |acc, item|
        acc[0] << item.to_steps[0]
        acc[1] << item.to_steps[1]
        acc
      end
    end
  end

  class Subject
    def initialize(value)
      if not /^shake_/ =~ value
        @button =
          if match = value.match(/_(\w+)\z/)
            match[1]
          else
            :unknown
          end
      end
      @type =
        if value.start_with?("toggle_")
          :toggle
        elsif value.start_with?("shake_left_stick")
          :shake_left_stick
        elsif value.start_with?("shake_right_stick")
          :shake_right_stick
        else
          :pressing
        end
    end

    def to_steps
      case @type
      when :toggle
        [@button.to_sym, :none]
      when :pressing
        [@button.to_sym, @button.to_sym]
      when :shake_left_stick
        [:tilt_left_stick_completely_to_left, :tilt_left_stick_completely_to_right]
      when :shake_right_stick
        [:tilt_right_stick_completely_to_up, :tilt_right_stick_completely_to_down]
      end
    end
  end

  RESERVED_WORD_NONE = :none
  RESERVED_WORDS = {
    RESERVED_WORD_NONE => true,
  }
  DYNAMIC_IKAROLE_START_DEGREE = -50
  DYNAMIC_IKAROLE_END_DEGREE = 50
  DYNAMIC_IKAROLE_OFFSET_DEGREE = 60
  DYNAMIC_IKAROLE_HOLD_FRAMES = 4

  def initialize(steps, context: {})
    @steps = steps.map(&:to_s)
    @context = context
  end

  # @return [Arary<Symbol>]
  def build
    steps = @steps.flat_map { |step|
      if is_reserved?(step: step) || v1_format?(step: step)
        step.to_sym
      elsif value = build_if_v2_format?(step: step)
        value
      else
        nil
      end
    }

    steps.compact
  end

  private

  def is_reserved?(step: )
    RESERVED_WORDS[step.to_sym]
  end

  def v1_format?(step: )
    if is_button(step)
      step
    end
  end

  def build_if_v2_format?(step: )
    # no-op command
    if(match = step.match(%r!wait_for_([\d_]+)(sec)?\z!))
      sec = match[1]
      return [
        { continue_for: to_f(sec),
          steps: [:none],
        }
      ]
    end

    # NOTE: マクロ構文で生成したいけど、スティックとボタン同時押しの構文が思いつかないので、ハードコードする
    if /^forward_ikarole1/ =~ step
      # NOTE: 0degはx: 1, y: 0, 90degはx: 0, y: 1, 180degはx: -1, y: 0.
      # NOTE: スティックを前方に倒している状態で270度回転させる
      for_forward_ikarole_steps = [
        [:tilt_left_stick_completely_to_0deg, :b],
        [:tilt_left_stick_completely_to_90deg],
      ]
      return { steps: for_forward_ikarole_steps }
    end

    if /^dynamic_ikarole/ =~ step
      current_degree = @context[:left_stick_degree] || 0
      start_degree = normalize_degree(current_degree + DYNAMIC_IKAROLE_START_DEGREE)
      end_degree = normalize_degree(
        if DYNAMIC_IKAROLE_END_DEGREE
          current_degree + DYNAMIC_IKAROLE_END_DEGREE
        else
          start_degree + DYNAMIC_IKAROLE_OFFSET_DEGREE
        end
      )
      start_step = :"tilt_left_stick_completely_to_#{start_degree}deg"
      end_step = :"tilt_left_stick_completely_to_#{end_degree}deg"
      return { steps: Array.new(DYNAMIC_IKAROLE_HOLD_FRAMES) { [start_step] } + [[end_step, :b], [end_step, :b]] }
    end

    if /^forward_ikarole_r/ =~ step
      for_forward_ikarole_steps = [
        [:tilt_left_stick_completely_to_0deg],
        [:tilt_left_stick_completely_to_0deg],
        [:tilt_left_stick_completely_to_0deg],
        [:tilt_left_stick_completely_to_0deg],
        [:tilt_left_stick_completely_to_140deg, :b],
      ]
      return { steps: for_forward_ikarole_steps }
    end

    if /^forward_ikarole_l/ =~ step
      for_forward_ikarole_steps = [
        [:tilt_left_stick_completely_to_180deg],
        [:tilt_left_stick_completely_to_180deg],
        [:tilt_left_stick_completely_to_180deg],
        [:tilt_left_stick_completely_to_180deg],
        [:tilt_left_stick_completely_to_40deg, :b],
      ]
      return { steps: for_forward_ikarole_steps }
    end

    if /^backward_ikarole_r/ =~ step
      for_backward_ikarole_steps = [
        [:tilt_left_stick_completely_to_0deg],
        [:tilt_left_stick_completely_to_0deg],
        [:tilt_left_stick_completely_to_0deg],
        [:tilt_left_stick_completely_to_0deg],
        [:tilt_left_stick_completely_to_220deg, :b],
      ]
      return { steps: for_backward_ikarole_steps }
    end

    if /^backward_ikarole_l/ =~ step
      for_backward_ikarole_steps = [
        [:tilt_left_stick_completely_to_180deg],
        [:tilt_left_stick_completely_to_180deg],
        [:tilt_left_stick_completely_to_180deg],
        [:tilt_left_stick_completely_to_180deg],
        [:tilt_left_stick_completely_to_320deg, :b],
      ]
      return { steps: for_backward_ikarole_steps }
    end

    if /^right_ikarole_r/ =~ step
      for_right_ikarole_steps = [
        [:tilt_left_stick_completely_to_270deg],
        [:tilt_left_stick_completely_to_270deg],
        [:tilt_left_stick_completely_to_270deg],
        [:tilt_left_stick_completely_to_270deg],
        [:tilt_left_stick_completely_to_50deg, :b],
      ]
      return { steps: for_right_ikarole_steps }
    end

    if /^right_ikarole_l/ =~ step
      for_right_ikarole_steps = [
        [:tilt_left_stick_completely_to_90deg],
        [:tilt_left_stick_completely_to_90deg],
        [:tilt_left_stick_completely_to_90deg],
        [:tilt_left_stick_completely_to_90deg],
        [:tilt_left_stick_completely_to_310deg, :b],
      ]
      return { steps: for_right_ikarole_steps }
    end

    if /^left_ikarole_r/ =~ step
      for_left_ikarole_steps = [
        [:tilt_left_stick_completely_to_90deg],
        [:tilt_left_stick_completely_to_90deg],
        [:tilt_left_stick_completely_to_90deg],
        [:tilt_left_stick_completely_to_90deg],
        [:tilt_left_stick_completely_to_230deg, :b],
      ]
      return { steps: for_left_ikarole_steps }
    end

    if /^left_ikarole_l/ =~ step
      for_left_ikarole_steps = [
        [:tilt_left_stick_completely_to_270deg],
        [:tilt_left_stick_completely_to_270deg],
        [:tilt_left_stick_completely_to_270deg],
        [:tilt_left_stick_completely_to_270deg],
        [:tilt_left_stick_completely_to_130deg, :b],
      ]
      return { steps: for_left_ikarole_steps }
    end

    if /^rotation_left_stick/ =~ step
      roll_left_stick_steps = 0.step(359, 17).map { |x| ["tilt_left_stick_completely_to_#{x}deg".to_sym] }
      return { steps: roll_left_stick_steps }
    end

    if %r!^(pressing_|toggle_|shake_left_stick_|shake_right_stick_)! =~ step && (subjects = step.scan(%r!pressing_[^_]+|shake_left_stick|shake_right_stick|toggle_[^_]+!)) && (match = step.match(%r!_for_([\d_]+)(sec)?\z!))
      if sec = match[1]
        return {
          continue_for: to_f(sec),
          steps: SubjectMerger.merge(subjects.map { |x| Subject.new(x) }).select { |x|
            if x.is_a?(Array)
              x.select { |y| is_button(y) || RESERVED_WORD_NONE == y || is_stick_step(y) }
            else
              is_button(x) || RESERVED_WORD_NONE == x || is_stick_step(x)
            end
          },
        }
      end
    end

    if %r!^(pressing_|toggle_|shake_left_stick_|shake_right_stick_)! =~ step && (subjects = step.scan(%r!pressing_[^_]+|shake_left_stick|shake_right_stick|toggle_[^_]+!))
      return SubjectMerger.merge(subjects.map { |x| Subject.new(x) }).select { |x|
        if x.is_a?(Array)
          x.select { |y| is_button(y) || RESERVED_WORD_NONE == y || is_stick_step(y) }
        else
          is_button(x) || RESERVED_WORD_NONE == x || is_stick_step(x)
        end
      }
    end
  end

  # @return [Boolean]
  def is_button(step)
    !!ProconBypassMan::Procon::ButtonCollection::BUTTONS_MAP[step.to_sym]
  end

  def is_stick_step(step)
    !!(step.to_s =~ /\Atilt_(left|right)_stick_/)
  end

  def to_f(value)
    if value.include?("_")
      value.sub("_", ".").to_f
    else
      value.to_f
    end
  end

  def normalize_degree(degree)
    degree.round % 360
  end
end
