class RemoveRoleFromUsers < ActiveRecord::Migration[6.0]
  def up
    remove_column :users, :role
    remove_column :accounts, :collaborators_checked_at
  end

  def down
    raise IrreversibleMigration
  end
end
