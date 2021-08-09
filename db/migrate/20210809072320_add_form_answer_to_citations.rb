class AddFormAnswerToCitations < ActiveRecord::Migration[6.0]
  def change
    add_reference :citations, :form_answer, index: true, foreigh_key: true
  end
end
