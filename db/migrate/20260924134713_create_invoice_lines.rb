class CreateInvoiceLines < ActiveRecord::Migration[8.1]
  def change
    create_table :invoice_lines do |t|
      t.references :invoice, null: false, foreign_key: true
      t.string :description, null: false
      t.decimal :quantity, precision: 12, scale: 2, null: false, default: 1
      t.decimal :unit_price, precision: 12, scale: 2, null: false, default: 0
      t.decimal :vat_rate, precision: 5, scale: 2, null: false, default: 20

      t.timestamps
    end
  end
end
