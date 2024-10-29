# This migration comes from spree_product_videos (originally 20240927142931)
class RemoveUrlfromSpreeProductVideo < ActiveRecord::Migration[7.1]
  def change
    remove_column :spree_product_videos, :url
  end
end
