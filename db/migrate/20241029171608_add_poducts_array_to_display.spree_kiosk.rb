# This migration comes from spree_kiosk (originally 20240826104430)
class AddPoductsArrayToDisplay < ActiveRecord::Migration[7.1]
  def self.up
    add_column :spree_displays, :products_array, :integer, array: true, default: []
  end

  def self.down
    remove_column :spree_displays, :products_array
  end
end
