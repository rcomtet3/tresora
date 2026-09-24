def seed_invoice(number:, client:, issued_on:, due_on:, status:, notes:, lines:)
  invoice = Invoice.find_or_initialize_by(number: number)
  invoice.assign_attributes(
    client: client,
    issued_on: issued_on,
    due_on: due_on,
    status: status,
    notes: notes
  )
  lines.each do |attributes|
    line = invoice.invoice_lines.find_or_initialize_by(description: attributes[:description])
    line.assign_attributes(attributes.except(:description))
  end

  invoice.save!
end

acme = Client.find_or_create_by!(email: "camille@acme-studio.fr") do |client|
  client.name = "Camille Bernard"
  client.company = "Acme Studio"
  client.address = "12 rue des Lilas, 75011 Paris"
end

studio_lumen = Client.find_or_create_by!(email: "marc@studio-lumen.fr") do |client|
  client.name = "Marc Leroy"
  client.company = "Studio Lumen"
  client.address = "8 avenue Victor Hugo, 69006 Lyon"
end

seed_invoice(
  number: "F2026-001",
  client: acme,
  issued_on: Date.current - 10,
  due_on: Date.current + 20,
  status: "sent",
  notes: "Merci pour votre confiance.",
  lines: [
    { description: "Audit et conseil", quantity: 2, unit_price: 500, vat_rate: 20 },
    { description: "Support mensuel", quantity: 1, unit_price: 150, vat_rate: 20 }
  ]
)

seed_invoice(
  number: "F2026-002",
  client: acme,
  issued_on: Date.current - 40,
  due_on: Date.current - 10,
  status: "sent",
  notes: "Relance à prévoir.",
  lines: [
    { description: "Refonte du site", quantity: 1, unit_price: 1800, vat_rate: 20 }
  ]
)

seed_invoice(
  number: "F2026-003",
  client: studio_lumen,
  issued_on: Date.current - 35,
  due_on: Date.current - 5,
  status: "paid",
  notes: "",
  lines: [
    { description: "Interface web", quantity: 1, unit_price: 1200, vat_rate: 20 }
  ]
)

seed_invoice(
  number: "F2026-004",
  client: studio_lumen,
  issued_on: Date.current - 2,
  due_on: Date.current + 28,
  status: "draft",
  notes: "Proposition en cours de validation.",
  lines: [
    { description: "Atelier de découverte", quantity: 1, unit_price: 450, vat_rate: 20 }
  ]
)

puts "Tresora demo data loaded: #{Client.count} clients, #{Invoice.count} invoices."
