class Eligibility::Validation::MoreThanTwoValidation < Eligibility::Validation::Base
  def valid?
    answer.to_i > 2
  end
end
