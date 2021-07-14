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

  property :organization_kind,
            values: %w[business charity],
            label: "What kind of organisation is it?",
            accept: :not_nil

  property :industry,
            values: %w[product_business service_business either_business],
            label: "Is your business mainly a:",
            accept: :not_nil,
            if: proc { !organization_kind_value || !organization_kind.charity? }

  property :self_contained_enterprise,
            boolean: true,
            label: "Is your organisation a self-contained operational unit?",
            accept: :true

  property :current_holder,
           values: %w[yes no i_dont_know],
           label: "Are you a current Queen's Award holder in any category?",
           accept: :not_nil

  def eligible?
    current_step_index = questions.index(current_step) || questions.size - 1
    previous_questions = questions[0..current_step_index]

    answers.any? && answers.all? do |question, answer|
      if previous_questions.include?(question.to_sym)
        answer_valid?(question, answer)
      else
        true
      end
    end
  end

  def save_as_eligible!
    self.organization_kind = 'charity'
    self.based_in_uk = true
    self.are_majority_volunteers = true
    self.self_contained_enterprise = true
    self.has_at_least_three_people = true

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
