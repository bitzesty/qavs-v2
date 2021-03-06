class Account < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :form_answers, dependent: :nullify

  has_many :eligibilities, dependent: :destroy
  has_many :basic_eligibilities, class_name: 'Eligibility::Basic'

  belongs_to :owner, class_name: 'User', autosave: false, inverse_of: :owned_account
  validates :owner, presence: true

  def basic_eligibility
    basic_eligibilities.first
  end

  def collaborators_with(user)
    users.confirmed.to_a.prepend(user).uniq.reject { |c| c.blank? }
  end

  def collaborators_without(user)
    users.not_including(user).by_email
  end

  def has_collaborators?
    users.count > 1
  end

  def has_no_collaborators?
    !has_collaborators?
  end

  def other_submitted_applications(excluded_form_answer)
    form_answers.submitted.where.not(id: excluded_form_answer.id).joins(:award_year).order("award_years.year DESC")
  end
end
