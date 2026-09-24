class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[show edit update destroy mark_as_sent mark_as_paid]

  def index
    @invoices = Invoice.includes(:client, :invoice_lines).recent
    @draft_count = @invoices.count(&:draft?)
    @overdue_count = @invoices.count(&:overdue?)
    @outstanding_total = @invoices.reject { |invoice| invoice.draft? || invoice.paid? }.sum(&:total_ttc)
  end

  def show
  end

  def new
    @invoice = Invoice.new(issued_on: Date.current, due_on: Date.current + 30, status: "draft")
    @invoice.invoice_lines.build
  end

  def create
    @invoice = Invoice.new(invoice_params)

    if @invoice.save
      redirect_to @invoice, notice: "La facture a été créée."
    else
      @invoice.invoice_lines.build if @invoice.invoice_lines.empty?
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @invoice.invoice_lines.build if @invoice.invoice_lines.empty?
  end

  def update
    if @invoice.update(invoice_params)
      redirect_to @invoice, notice: "La facture a été mise à jour."
    else
      @invoice.invoice_lines.build if @invoice.invoice_lines.empty?
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @invoice.destroy!
    redirect_to invoices_path, notice: "La facture a été supprimée.", status: :see_other
  end

  def mark_as_sent
    update_status("sent", "La facture est marquée comme envoyée.")
  end

  def mark_as_paid
    update_status("paid", "La facture est marquée comme payée.")
  end

  private

  def set_invoice
    @invoice = Invoice.includes(:client, :invoice_lines).find(params[:id])
  end

  def update_status(status, notice)
    if @invoice.update(status: status)
      redirect_to @invoice, notice: notice
    else
      redirect_to @invoice, alert: @invoice.errors.full_messages.to_sentence
    end
  end

  def invoice_params
    params.require(:invoice).permit(
      :client_id,
      :number,
      :issued_on,
      :due_on,
      :status,
      :notes,
      invoice_lines_attributes: %i[id description quantity unit_price vat_rate _destroy]
    )
  end
end
