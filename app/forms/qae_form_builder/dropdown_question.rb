class QAEFormBuilder
  class DropdownQuestionValidator < OptionsQuestionValidator
  end

  class DropdownQuestionBuilder < OptionsQuestionBuilder
    def nominee_activities
      NomineeActivityHelper::ACTIVITY_MAPPINGS.each do |value, text|
        @q.options << QuestionAnswerOption.new(value, text)
      end
    end
  end

  class DropdownQuestion < OptionsQuestion
  end
end
