class Eligibility::Validation::NotYesValidation < Eligibility::Validation::Base
  def valid?
    answer.present? && answer != 'yes'
  end
end
