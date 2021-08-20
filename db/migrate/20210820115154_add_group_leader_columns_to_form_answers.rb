class AddGroupLeaderColumnsToFormAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :form_answers, :group_leader_name, :string
    add_column :form_answers, :group_leader_position, :string
    add_column :form_answers, :group_leader_address, :hstore, default: {}
    add_column :form_answers, :group_leader_email, :string
    add_column :form_answers, :group_leader_phone, :string
  end
end
