class QAEFormBuilder
  class AssessorDetailsQuestionValidator < QuestionValidator
  end

  class AssessorDetailsQuestionDecorator < QuestionDecorator
    def required_sub_fields
      if sub_fields.present?
        sub_fields
      else
        [
          {full_name: "Full name"},
          {email: "Email"},
          {phone_number: "Phone number"}
        ]
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
