class CreateCitations < ActiveRecord::Migration[6.0]
  def change
    create_table :citations do |t|
      t.string :group_name
      t.text :body
      t.timestamp :completed_at
      t.references :group_leader, index: true, null: false

      t.timestamps
    end
    add_foreign_key :citations, :group_leaders
  end
end
