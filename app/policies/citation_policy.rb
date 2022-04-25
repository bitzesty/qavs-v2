class CitationPolicy < ApplicationPolicy
  def update?
    group_leader? && record.form_answer.id == subject.form_answer_id
  end
  alias :reject? :update?
end
