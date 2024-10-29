# This migration comes from spree_kiosk (originally 20240917100752)
class RemoveQrCodeUrlAttribute < ActiveRecord::Migration[7.1]
  def change
    remove_column :spree_displays, :qr_code_url
    remove_column :spree_display_products, :qr_code_url
  end
end
