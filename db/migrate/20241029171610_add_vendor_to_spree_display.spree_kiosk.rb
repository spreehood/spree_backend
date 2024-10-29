# This migration comes from spree_kiosk (originally 20240904140637)
class AddVendorToSpreeDisplay < ActiveRecord::Migration[7.1]
  def self.up
    add_column :spree_displays, :vendor_id, :integer
  end

  def self.down
    remove_column :spree_displays, :vendor_id
  end
end
