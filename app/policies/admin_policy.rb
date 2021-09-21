class AdminPolicy < UserPolicy
  def destroy?
    admin? && subject != record
  end

  def update_account_details?
    admin?
  end
end
