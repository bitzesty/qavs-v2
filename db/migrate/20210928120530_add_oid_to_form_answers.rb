class AddOidToFormAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :form_answers, :oid, :string
  end
end
