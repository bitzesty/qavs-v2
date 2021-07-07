class AddCeremonialCountyIdToFormAnswer < ActiveRecord::Migration[6.0]
  def change
    add_column :form_answers, :ceremonial_county_id, :integer

    add_index :form_answers, [:award_year_id, :ceremonial_county_id]
  end
end
