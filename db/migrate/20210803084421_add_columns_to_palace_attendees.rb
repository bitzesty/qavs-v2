class AddColumnsToPalaceAttendees < ActiveRecord::Migration[6.0]
  def change
    add_column :palace_attendees, :relationship, :string
    add_column :palace_attendees, :disabled_access, :boolean
    add_column :palace_attendees, :preferred_date, :string
    add_column :palace_attendees, :alternative_date, :string
  end
end
