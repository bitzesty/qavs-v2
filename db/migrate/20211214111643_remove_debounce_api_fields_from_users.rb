class RemoveDebounceApiFieldsFromUsers < ActiveRecord::Migration[6.0]
  def up
    remove_column :users, :debounce_api_response_code
    remove_column :users, :marked_at_bounces_email
    remove_column :users, :debounce_api_latest_check_at
  end

  def down
    add_column :users, :debounce_api_response_code, :string
    add_column :users, :marked_at_bounces_email, :boolean, default: false
    add_column :users, :debounce_api_latest_check_at, :datetime
  end
end
