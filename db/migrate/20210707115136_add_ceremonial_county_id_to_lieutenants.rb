class AddCeremonialCountyIdToLieutenants < ActiveRecord::Migration[6.0]
  def change
    add_column :lieutenants, :ceremonial_county_id, :integer
    add_index :lieutenants, :ceremonial_county_id
  end
end
