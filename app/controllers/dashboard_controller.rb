class DashboardController < ApplicationController
  def index
    @all_invoices = Invoice.includes(:client, :invoice_lines).recent.to_a
    @invoices = @all_invoices.first(5)
    @clients_count = Client.count
    @draft_count = @all_invoices.count(&:draft?)
    @overdue_count = @all_invoices.count(&:overdue?)
    @total_billed = @all_invoices.sum(&:total_ttc)
    @collected = @all_invoices.select(&:paid?).sum(&:total_ttc)
    @outstanding = @all_invoices.reject { |invoice| invoice.draft? || invoice.paid? }.sum(&:total_ttc)
  end
end
