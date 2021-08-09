class Citation < ApplicationRecord
  belongs_to :form_answer

  validates :form_answer_id, uniqueness: true
  validates :group_name, :body, presence: true
end
