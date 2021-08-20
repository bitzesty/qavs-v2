class AddCountryToCeremonialCounties < ActiveRecord::Migration[6.0]
  def change
    add_column :ceremonial_counties, :country, :string
  end
end
