# This migration comes from spree_multi_vendor (originally 20240923055341)
class AddVendorIdToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :spree_orders, :vendor_id, :bigint
  end
end
