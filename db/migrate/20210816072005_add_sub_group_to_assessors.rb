class AddSubGroupToAssessors < ActiveRecord::Migration[6.0]
  def change
    add_column :assessors, :sub_group, :string
  end
end
