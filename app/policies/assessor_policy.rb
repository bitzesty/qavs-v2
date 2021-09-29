class AssessorPolicy < AdminPolicy
  def update_account_details?
    admin? || assessor?
  end
end
