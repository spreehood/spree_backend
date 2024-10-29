# This migration comes from spree_products_qa (originally 20140212082146)
class CreateSpreeProductAnswers < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_product_answers do |t|
      t.integer :product_question_id
      t.integer :user_id
      t.text :content

      t.timestamps
    end
    add_index :spree_product_answers, :product_question_id
  end
end
