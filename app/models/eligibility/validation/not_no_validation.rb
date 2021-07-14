class Eligibility::Validation::NotNoValidation < Eligibility::Validation::Base
  def valid?
    answer.present? && eligibility.are_majority_volunteers != 'false'
  end
end
