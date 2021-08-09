class CitationPolicy < ApplicationPolicy
  def update?
    group_leader?
  end
end
