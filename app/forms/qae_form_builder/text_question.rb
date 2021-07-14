class QAEFormBuilder
  class TextQuestionValidator < QuestionValidator
  end

  class TextQuestionBuilder < QuestionBuilder
    def style style
      @q.style = style
    end

    def type type
      @q.type = type
    end

    def default_value(q_key)
      @q.default_value_key = q_key
    end
  end

  class TextQuestion < Question
    attr_accessor :type, :style, :default_value_key
  end

  class TextQuestionDecorator < QuestionDecorator
    def input_value(options = {})
      super.presence || answers[delegate_obj.default_value_key]
    end
  end
end
