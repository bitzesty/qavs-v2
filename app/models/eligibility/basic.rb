class Eligibility::Basic < Eligibility
  AWARD_NAME = 'General'
  after_save :set_passed

  property :based_in_uk,
            boolean: true,
            label: "Is the group based in the UK, the Channel Islands or the Isle of Man?",
            accept: :true

  property :has_at_least_three_people,
            boolean: true,
            label: "Is the group comprised of at least three people?",
            accept: :true

  property :are_majority_volunteers,
            values: %w[true false na],
            label: "Are the majority of them volunteers?",
            accept: :not_no

  property :national_organisation,
            boolean: true,
            label: "Was it set up as a national organisation (e.g. for all England/Wales/Scotland/N. Ireland)?",
            accept: :false

  property :benefits_animals_only,
            boolean: true,
            label: "Does it only benefit animals rather than people?",
            accept: :false

  property :years_operating,
            positive_integer: true,
            label: "How long has the group been operating? (must be at least 3 years)",
            accept: :more_than_two

  property :current_holder,
           values: %w[yes no i_dont_know],
           label: "Are you a current Queen's Award holder in any category?",
           accept: :not_nil

  def eligible?
    current_step_index = questions.index(current_step) || questions.size - 1
    previous_questions = questions[0..current_step_index]

    answers.present? && answers.all? do |question, answer|
      if previous_questions.include?(question.to_sym)
        answer_valid?(question, answer)
      else
        true
      end
    end
  end

  def save_as_eligible!
    self.national_organisation = false
    self.based_in_uk = true
    self.are_majority_volunteers = true
    self.benefits_animals_only = false
    self.has_at_least_three_people = true
    self.years_operating = 3

    save
  end

  private

  def set_passed
    if (current_step == questions.last) && eligible?
      update_column(:passed, true)
    else
      update_column(:passed, false)
    end
  end
end
