class AddSubGroupToFormAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :form_answers, :sub_group, :string
  end
end
