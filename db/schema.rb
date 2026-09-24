# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_24_134713) do
  create_table "clients", force: :cascade do |t|
    t.text "address"
    t.string "company"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_clients_on_email"
  end

  create_table "invoice_lines", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description", null: false
    t.integer "invoice_id", null: false
    t.decimal "quantity", precision: 12, scale: 2, default: "1.0", null: false
    t.decimal "unit_price", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.decimal "vat_rate", precision: 5, scale: 2, default: "20.0", null: false
    t.index ["invoice_id"], name: "index_invoice_lines_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "client_id", null: false
    t.datetime "created_at", null: false
    t.date "due_on", null: false
    t.date "issued_on", null: false
    t.text "notes"
    t.string "number", null: false
    t.string "status", default: "draft", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_invoices_on_client_id"
    t.index ["number"], name: "index_invoices_on_number", unique: true
    t.index ["status"], name: "index_invoices_on_status"
  end

  add_foreign_key "invoice_lines", "invoices"
  add_foreign_key "invoices", "clients"
end
