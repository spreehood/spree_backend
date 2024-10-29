# This migration comes from spree_gateways_nepal (originally 20240730060557)
class UpdateSpreeKhaltiPaymentSources < ActiveRecord::Migration[6.0]
  def change
    change_table :spree_khalti_payment_sources do |t|
      # Add new columns
      t.string :pidx
      t.integer :total_amount
      t.string :status
      t.integer :transaction_id
      t.integer :fee
    end
  end
end