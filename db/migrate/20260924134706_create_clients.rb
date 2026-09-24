class CreateClients < ActiveRecord::Migration[8.1]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :email
      t.string :company
      t.text :address

      t.index :email

      t.timestamps
    end
  end
end
