class ChangeDataTypeForGroupLeaderAddress < ActiveRecord::Migration[6.0]
  def up
    change_column_default :form_answers, :group_leader_address, nil
    change_column :form_answers, :group_leader_address, :json, using: "group_leader_address::JSON"
  end

  def down
    change_column :form_answers, :group_leader_address, :hstore
    change_column_default :form_answers, :group_leader_address, {}
  end
end
