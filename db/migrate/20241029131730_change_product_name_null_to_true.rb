class ChangeProductNameNullToTrue < ActiveRecord::Migration[8.0]
  def change
    change_column_null :spree_products, :name, true
  end
end
