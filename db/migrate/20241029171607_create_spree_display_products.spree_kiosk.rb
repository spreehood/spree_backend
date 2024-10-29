# This migration comes from spree_kiosk (originally 20240826091906)
class CreateSpreeDisplayProducts < SpreeExtension::Migration[4.2]
  def self.up
    create_table :spree_display_products do |t|
      t.integer :product_id
      t.integer :display_id
      t.string :qr_code_url
      t.string :video_url

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :spree_display_products
  end
end
