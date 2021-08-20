class AddUniqCheckToCerimonialCounty < ActiveRecord::Migration[6.0]
  def change
    add_index :ceremonial_counties, :name, unique: true
  end
end
