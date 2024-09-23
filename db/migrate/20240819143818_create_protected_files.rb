class CreateProtectedFiles < ActiveRecord::Migration[7.1]
  def change
    create_table :protected_files, id: :uuid do |t|
      t.belongs_to :entity, polymorphic: true
      t.string :file

      t.datetime :created_at, precision: 6, null: false
      t.datetime :last_downloaded_at, precision: 6
    end
  end
end
