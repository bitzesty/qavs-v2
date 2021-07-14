module EligibilityHelper
  def final_eligibility_page?(step)
    !step || step.to_s == "wicked_finish"
  end

  def eligibility_volunteer_majority_question_ops
    [
      ['Yes', 'true'],
      ['No (permitted in exceptional circumstances)', 'false'],
      ["Don't know", 'na']
    ]
  end

  def eligibility_volunteer_majority_formatted_answer(answer)
    case answer
    when 'true'
      'Yes'
    when 'false'
      'No (permitted in exceptional circumstances)'
    when 'na'
      "Don't know"
    end
  end
end
