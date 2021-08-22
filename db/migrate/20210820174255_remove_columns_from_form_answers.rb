class RemoveColumnsFromFormAnswers < ActiveRecord::Migration[6.0]
  def change
    remove_column :form_answers, :group_leader_name
    remove_column :form_answers, :group_leader_position
    remove_column :form_answers, :group_leader_address
    remove_column :form_answers, :group_leader_email
    remove_column :form_answers, :group_leader_phone
  end
end
