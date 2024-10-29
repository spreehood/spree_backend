# This migration comes from spree_kiosk (originally 20240823075915)
class CreateDisplays < SpreeExtension::Migration[4.2]
  def self.up
    create_table :spree_displays do |t|
      t.string :name
      t.string :screen_size
      t.string :orientation
      t.string :display_type

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :spree_displays
  end
end
