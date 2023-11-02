class QaeFormBuilder

  class QaeFormDecorator < QaeDecorator

    def form_name
      @decorator_options[:form_name] || 'form'
    end

    def progress
      required_visible_questions_filled.to_f / required_visible_questions_total
    end

    def required_visible_questions_filled
      count_questions :required_visible_questions_filled
    end

    def required_visible_questions_total
      count_questions :required_visible_questions_total
    end

    private

    def count_questions(meth)
      steps.map do |step|
        if step.opts[:id] != :local_assessment
          step.send(meth)
        else
          0
        end
      end.reduce(:+)
    end
  end
end
