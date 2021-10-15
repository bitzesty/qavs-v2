class AddOidToLieutenants < ActiveRecord::Migration[6.0]
  def change
    add_column :lieutenants, :oid, :string
  end
end
