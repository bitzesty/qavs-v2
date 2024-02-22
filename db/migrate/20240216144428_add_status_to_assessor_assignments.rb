class AddStatusToAssessorAssignments < ActiveRecord::Migration[7.1]
  def change
    add_column :assessor_assignments, :status, :string
  end
end
