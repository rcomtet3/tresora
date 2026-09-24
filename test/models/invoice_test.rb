require "test_helper"

class InvoiceTest < ActiveSupport::TestCase
  test "assigns default dates and draft status" do
    invoice = Invoice.new(client: clients(:acme), number: "F2026-099")

    assert invoice.save
    assert_equal "draft", invoice.status
    assert_equal Date.current, invoice.issued_on
    assert_equal issued_on_plus_thirty_days(invoice.issued_on), invoice.due_on
  end

  test "requires the due date to be after the issue date" do
    invoice = Invoice.new(
      client: clients(:acme),
      number: "F2026-100",
      issued_on: Date.current,
      due_on: Date.current - 1
    )

    assert_not invoice.valid?
    assert_includes invoice.errors[:due_on], "doit être postérieure à la date d'émission"
  end

  test "calculates totals from its lines" do
    invoice = invoices(:acme_current)

    assert_equal BigDecimal("1150.0"), invoice.total_ht
    assert_equal BigDecimal("230.0"), invoice.total_vat
    assert_equal BigDecimal("1380.0"), invoice.total_ttc
  end

  test "is overdue when a sent invoice is past due" do
    invoice = Invoice.create!(
      client: clients(:acme),
      number: "F2026-101",
      issued_on: 40.days.ago.to_date,
      due_on: 10.days.ago.to_date,
      status: "sent"
    )

    assert invoice.overdue?
    assert_equal "overdue", invoice.display_status
    assert_includes Invoice.overdue, invoice
  end

  test "does not mark paid invoices as overdue" do
    assert_not invoices(:acme_paid).overdue?
    assert_equal "paid", invoices(:acme_paid).display_status
  end

  private

  def issued_on_plus_thirty_days(date)
    date + 30
  end
end
