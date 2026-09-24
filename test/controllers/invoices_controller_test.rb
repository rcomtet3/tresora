require "test_helper"

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  test "lists invoices" do
    get invoices_path

    assert_response :success
    assert_select "h1", "Factures"
    assert_select "td", text: /F2026-001/
  end

  test "renders the nested invoice form" do
    get new_invoice_path

    assert_response :success
    assert_select "form[data-controller='line-items']"
    assert_select "select[name='invoice[client_id]']"
  end

  test "creates an invoice with lines" do
    assert_difference -> { Invoice.count }, 1 do
      assert_difference -> { InvoiceLine.count }, 1 do
        post invoices_path, params: {
          invoice: {
            client_id: clients(:acme).id,
            number: "F2026-200",
            issued_on: Date.current,
            due_on: Date.current + 30,
            status: "draft",
            invoice_lines_attributes: {
              "0" => {
                description: "Mission de conseil",
                quantity: "2",
                unit_price: "300",
                vat_rate: "20"
              }
            }
          }
        }
      end
    end

    invoice = Invoice.find_by!(number: "F2026-200")
    assert_redirected_to invoice_path(invoice)
    assert_equal BigDecimal("600.0"), invoice.total_ht
  end

  test "renders errors for an invoice without a client or line" do
    assert_no_difference -> { Invoice.count } do
      post invoices_path, params: { invoice: { number: "F2026-201" } }
    end

    assert_response :unprocessable_entity
    assert_select ".form-errors"
  end

  test "moves a draft invoice to sent" do
    invoice = invoices(:lumen_draft)

    patch mark_as_sent_invoice_path(invoice)

    assert_redirected_to invoice_path(invoice)
    assert invoice.reload.sent?
  end

  test "shows an invoice" do
    get invoice_path(invoices(:acme_current))

    assert_response :success
    assert_select "h1", "Facture F2026-001"
    assert_select ".invoice-totals__grand", /1 380,00/
  end
end
