class AddSecondaryActivityToFormAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :form_answers, :secondary_activity, :string
  end
end
