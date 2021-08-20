class AddIniligibilityReasonsToFormAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :form_answers, :ineligible_reason_nominator, :string
    add_column :form_answers, :ineligible_reason_group, :string
  end
end
