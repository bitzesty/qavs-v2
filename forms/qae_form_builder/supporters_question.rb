class QaeFormBuilder
  class SupportersQuestionValidator < QuestionValidator
    MIN_LIMIT = 2

    def errors
      result = super

      letters = question.answers["supporter_letters_list"] || {}
      count = calculate_without_blanks(letters)

      if count < MIN_LIMIT
        result["supporters"] = "You must provide #{MIN_LIMIT} letters of support"
      end

      result
    end

    private

    def calculate_without_blanks(supporters)
      supporters.count do |sup|
        sup["support_letter_id"].present?
      end
    end
  end

  class SupportersQuestionBuilder < QuestionBuilder
    def limit(value)
      @q.limit = value
    end

    def default(value)
      @q.default = value
    end
  end

  class SupportersQuestion < Question
    attr_accessor :limit, :default
  end

  class SupportersQuestionDecorator < MultiQuestionDecorator
    def entities
      super
      
      collection = [].fill({}, 0, limit)
      @entities.each_with_index do |record, idx|
        collection[idx] = record
      end
      
      @entities = collection
    end
  end
end
