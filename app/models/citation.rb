class Citation < ApplicationRecord
  belongs_to :group_leader

  validates :group_leader_id, uniqueness: true
  validates :group_name, :body, presence: true
end
