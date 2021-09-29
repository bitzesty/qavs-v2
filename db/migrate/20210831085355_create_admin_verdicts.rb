class CreateAdminVerdicts < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_verdicts do |t|
      t.string :outcome
      t.text :description
      t.references :form_answer, foreign_key: true

      t.timestamps
    end
  end
end
