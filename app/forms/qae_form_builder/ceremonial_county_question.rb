class QAEFormBuilder
  class CeremonialCountyQuestionValidator < OptionsQuestionValidator
  end

  class CeremonialCountyQuestionBuilder < OptionsQuestionBuilder
    def counties
      CeremonialCounty.all.each do |county|
        @q.options << QuestionAnswerOption.new(county.id, county.name)
      end
    end
  end

  class CeremonialCountyQuestion < DropdownQuestion
  end
end
