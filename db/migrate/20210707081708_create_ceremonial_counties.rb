class CreateCeremonialCounties < ActiveRecord::Migration[6.0]
  def change
    create_table :ceremonial_counties do |t|
      t.string :name

      t.timestamps
    end
  end
end
