class QAEFormBuilder

  class QAEForm
    attr_reader :title, :opts, :steps, :questions_by_key

    def initialize title, opts={}
      @title = title
      @opts = opts
      @steps = []

      @questions_by_key = {}
    end

    def [] key
      @questions_by_key[key]
    end

    def decorate options = {}
      QAEFormDecorator.new self, options
    end

    def step title, short_title, options = {}, &block
      step = Step.new self, title, short_title, options

      builder = StepBuilder.new step
      builder.instance_eval &block if block_given?
      @steps << step
      step
    end

    def current_steps(nomination, user)
      can_see_lieutenant_form = FormAnswerPolicy.new(user, nomination).lieutenant_assessment?

      @steps.select do |s|
        (s.opts[:id] != :lieutenants_assessment || can_see_lieutenant_form)
      end
    end
  end
end
