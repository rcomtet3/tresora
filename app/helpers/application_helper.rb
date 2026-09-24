module ApplicationHelper
  def format_euros(amount)
    "#{number_with_precision(amount || 0, precision: 2, delimiter: ' ', separator: ',')} €"
  end

  def format_date(date)
    date&.strftime("%d/%m/%Y")
  end

  def invoice_status_label(invoice)
    {
      "draft" => "Brouillon",
      "sent" => "Envoyée",
      "paid" => "Payée",
      "overdue" => "En retard"
    }.fetch(invoice.display_status, invoice.display_status)
  end

  def invoice_status_class(invoice)
    "badge--#{invoice.display_status}"
  end

  def initials_for(name)
    name.to_s.split.first(2).filter_map { |part| part.first&.upcase }.join
  end
end
