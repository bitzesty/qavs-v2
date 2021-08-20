class AddFormAnswerToGroupLeader < ActiveRecord::Migration[6.0]
  def change
    add_reference :group_leaders, :form_answer, index: true, foreign_key: true
  end
end
