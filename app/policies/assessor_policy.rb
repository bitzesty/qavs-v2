class AssessorPolicy < AdminPolicy
  def update?
    assessor? || admin?
  end
end
