class LieutenantPolicy < AdminPolicy
  def index?
    admin? || advanced_lieutenant?
  end

  def create?
    admin? || advanced_lieutenant?
  end

  def update?
    admin? || (advanced_lieutenant? && same_county?)
  end

  def destroy?
    admin? || (advanced_lieutenant? && subject != record && record.role.regular? && same_county?)
  end

  def update_account_details?
    admin? || lieutenant?
  end

  private

  def same_county?
    record.ceremonial_county == subject.ceremonial_county
  end
end
