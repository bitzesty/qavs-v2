class QAEFormBuilder
  class TextQuestionValidator < QuestionValidator
    # regex source: https://www.w3resource.com/javascript/form/email-validation.php
    EMAIL_REGEX = /\A\w+([\.\-\+]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,})+\z/

    def errors
      result = super

      if question.email? && question.input_value.present? && !question.input_value.match(EMAIL_REGEX)
        result[question.hash_key] = "Is not a valid email"
      end

      result
    end
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

    def email?
      type.to_s == "email"
    end
  end

  class TextQuestionDecorator < QuestionDecorator
    def input_value(options = {})
      super.presence || answers[delegate_obj.default_value_key]
    end
  end
end
