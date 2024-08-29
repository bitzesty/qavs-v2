class Eligibility::Basic < Eligibility
  AWARD_NAME = 'General'
  after_save :set_passed

  property :involved_with_group,
           boolean: true,
           label: "Are you a volunteer, employee or trustee of the group, or in any way involved with the running of the organisation?",
           accept: :false

  property :based_in_uk,
           boolean: true,
           label: "Is the group based in the UK, the Channel Islands or the Isle of Man?",
           accept: :true

  property :years_operating,
           positive_integer: true,
           label: "How many years has the group been in operation?",
           hint: "The group must have been operating for at least 3 years before nomination.",
           accept: :more_than_two

  property :has_at_least_three_people,
           boolean: true,
           label: "Is the group comprised of at least three volunteers?",
           accept: :true

  property :are_majority_volunteers,
           values: %w[true false na],
           label: "Are the majority of the group volunteers?",
           accept: :not_no

  property :national_organisation,
           boolean: true,
           label: "Was it set up as a national organisation - for example, for the whole of England, Wales, Scotland or Northern Ireland?",
           accept: :false

  property :local_area,
           boolean: true,
           label: "Does the group provide a specific and direct benefit to the local community?",
           hint: "Please note, KAVS is for local volunteer groups.",
           accept: :true

  property :provide_grants,
           boolean: true,
           label: "Is its main purpose to raise funds or provide grants for volunteer groups?",
           accept: :false

  property :benefits_animals_only,
           boolean: true,
           label: "Is its main focus benefiting animals rather than people?",
           accept: :false

  property :current_holder,
           values: %w[yes no i_dont_know],
           label: "Has the group received a KAVS/QAVS in the past?",
           accept: :not_yes

  def save_as_eligible!
    self.national_organisation = false
    self.based_in_uk = true
    self.has_at_least_three_people = true
    self.years_operating = 3
    self.are_majority_volunteers = true
    self.local_area = true
    self.provide_grants = false
    self.benefits_animals_only = false
    self.current_holder = "i_dont_know"
    self.involved_with_group = false

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
