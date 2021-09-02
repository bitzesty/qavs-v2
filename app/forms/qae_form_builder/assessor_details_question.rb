class QAEFormBuilder
  class AssessorDetailsQuestionValidator < QuestionValidator
    NO_VALIDATION_SUB_FIELDS = [:secondary_assessor_name]
    def errors
      result = super

      if question.required?
        question.required_sub_fields.each do |sub_field|
          suffix = sub_field.keys[0]
          if !question.input_value(suffix: suffix).present? && NO_VALIDATION_SUB_FIELDS.exclude?(suffix)
            result[question.hash_key(suffix: suffix)] ||= ""
            result[question.hash_key(suffix: suffix)] << " Can't be blank."
          end
        end
      end

      # need to add question-has-errors class
      result[question.hash_key] ||= "" if result.any?

      result
    end
  end

  class AssessorDetailsQuestionDecorator < QuestionDecorator
    def required_sub_fields
      if sub_fields.present?
        sub_fields
      else
        [
          { primary_assessor_name: "Full name of the first assessor" },
          { secondary_assessor_name: "Full name of the second assessor (if applicable)", ignore_validation: true }
        ]
      end
    end

    def rendering_sub_fields
      required_sub_fields.map do |f|
        [f.keys.first, f.values.first]
      end
    end
  end

  class AssessorDetailsQuestionBuilder < QuestionBuilder
    def sub_fields(fields)
      @q.sub_fields = fields
    end
  end

  class AssessorDetailsQuestion < Question
    attr_accessor :sub_fields
  end
end
