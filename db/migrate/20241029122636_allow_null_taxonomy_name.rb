class AllowNullTaxonomyName < ActiveRecord::Migration[8.0]
  def change
    change_column_null :spree_taxonomies, :name, true
  end
end
