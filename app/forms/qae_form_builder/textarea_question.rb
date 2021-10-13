class QAEFormBuilder
  class TextareaQuestionValidator < QuestionValidator
    def errors
      result = super

      words_length = ActionView::Base.full_sanitizer.sanitize(
        question.input_value.to_s
      ).split(" ")
       .reject do |a|
        a.blank?
      end.length

      chars_length = ActionView::Base.full_sanitizer.sanitize(
        question.input_value.to_s
      ).length

      word_limit = question.delegate_obj.words_max
      char_limit = question.delegate_obj.chars_max

      if word_limit && limit_with_buffer(word_limit) && words_length && words_length > limit_with_buffer(word_limit)
        result[question.hash_key] ||= ""
        result[question.hash_key] << " Exceeded the #{word_limit} words limit."
      end

      if char_limit && limit_with_buffer(char_limit) && chars_length && chars_length > limit_with_buffer(char_limit)
        result[question.hash_key] ||= ""
        result[question.hash_key] << " Exceeded the #{char_limit} characters limit."
      end

      result
    end
  end

  class TextareaQuestionBuilder < QuestionBuilder
    def rows(num)
      @q.rows = num
    end

    def words_max(num)
      @q.words_max = num
    end

    def chars_max(num)
      @q.chars_max = num
    end
  end

  class TextareaQuestion < Question
    attr_accessor :rows, :words_max, :chars_max
  end
end
