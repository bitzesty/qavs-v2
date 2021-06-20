class LieutenantPolicy < AdminPolicy
  def index?
    admin? || advanced_lieutenant?
  end

  def create?
    admin? || advanced_lieutenant?
  end

  def update?
    admin? || advanced_lieutenant?
  end

  def destroy?
    admin? || (advanced_lieutenant? && subject != record && record.role.regular?)
  end
end
