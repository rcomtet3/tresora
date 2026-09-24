require "test_helper"

class InvoiceLineTest < ActiveSupport::TestCase
  test "calculates VAT and total amounts" do
    line = invoice_lines(:acme_consulting)

    assert_equal BigDecimal("1000.0"), line.amount_ht
    assert_equal BigDecimal("200.0"), line.vat_amount
    assert_equal BigDecimal("1200.0"), line.amount_ttc
  end

  test "requires a positive quantity" do
    line = InvoiceLine.new(description: "Prestation", quantity: 0, unit_price: 100, vat_rate: 20)

    assert_not line.valid?
    assert_includes line.errors[:quantity], "must be greater than 0"
  end

  test "requires a valid VAT rate" do
    line = InvoiceLine.new(description: "Prestation", quantity: 1, unit_price: 100, vat_rate: 120)

    assert_not line.valid?
    assert_includes line.errors[:vat_rate], "must be less than or equal to 100"
  end
end
