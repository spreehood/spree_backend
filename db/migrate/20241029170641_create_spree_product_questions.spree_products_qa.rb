# This migration comes from spree_products_qa (originally 20140212082108)
class CreateSpreeProductQuestions < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_product_questions do |t|
      t.integer :product_id
      t.integer :user_id
      t.text :content
      t.boolean :is_visible, default: false

      t.timestamps
    end
    add_index :spree_product_questions, :product_id
  end
end
