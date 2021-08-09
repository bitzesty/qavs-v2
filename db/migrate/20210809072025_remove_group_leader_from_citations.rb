class RemoveGroupLeaderFromCitations < ActiveRecord::Migration[6.0]
  def change
    remove_reference(:citations, :group_leader, index: true, foreign_key: true)
  end
end
