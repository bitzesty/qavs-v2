class CreateNominationSearches < ActiveRecord::Migration[6.0]
  def change
    create_table :nomination_searches do |t|
      t.text :serialized_query
    end
  end
end
