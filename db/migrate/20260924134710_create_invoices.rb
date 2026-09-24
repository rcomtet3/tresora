class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices do |t|
      t.references :client, null: false, foreign_key: true
      t.string :number, null: false
      t.date :issued_on, null: false
      t.date :due_on, null: false
      t.string :status, null: false, default: "draft"
      t.text :notes

      t.index :number, unique: true
      t.index :status

      t.timestamps
    end
  end
end
