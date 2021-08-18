class CommentPolicy < ApplicationPolicy
  def create?
    return true if admin?
    lead_or_assigned?
  end

  def update?
    return true if admin?
    lead_or_assigned?
  end

  def destroy?
    record.author?(subject)
  end

  private

  def assigned?
    assessor? &&
      record.critical? &&
      subject.assigned?(record.commentable)
  end
end
