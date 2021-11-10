class DropAggregatedAwardYearPdfs < ActiveRecord::Migration[6.0]
  def up
    drop_table :aggregated_award_year_pdfs
  end

  def down
    create_table :aggregated_award_year_pdfs do |t|
      t.references :award_year, index: true, foreign_key: true
      t.string :award_category
      t.string :file
      t.string :type_of_report
      t.string :original_filename
      t.string :sub_type

      t.timestamps null: false
    end
  end
end
