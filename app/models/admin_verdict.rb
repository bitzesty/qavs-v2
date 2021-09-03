class AdminVerdict < ApplicationRecord
  extend Enumerize

  belongs_to :form_answer

  VERDICTS = [
    "shortlisted",
    "not_recommended",
    "no_royal_approval",
    "undecided",
    "awarded"
  ]

  enumerize :outcome, in: VERDICTS

  validates :description, :outcome, presence: true

  after_save :perform_nomination_state_transition

  private

  def perform_nomination_state_transition
    form_answer.state_machine.perform_transition(outcome)
  end
end
