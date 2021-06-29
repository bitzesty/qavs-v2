class AddNomineeActivityToFormAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :form_answers, :nominee_activity, :string
  end
end
