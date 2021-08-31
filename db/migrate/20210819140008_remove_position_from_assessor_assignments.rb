class RemovePositionFromAssessorAssignments < ActiveRecord::Migration[6.0]
  def up
    remove_column :assessor_assignments, :position
  end

  def down
    add_column :assessor_assignments, :position, :integer, null: false, default: 0
  end
end
