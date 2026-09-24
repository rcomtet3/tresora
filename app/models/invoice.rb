class Invoice < ApplicationRecord
  STATUSES = %w[draft sent paid].freeze

  belongs_to :client
  has_many :invoice_lines, -> { order(:id) }, dependent: :destroy

  accepts_nested_attributes_for :invoice_lines,
                                allow_destroy: true,
                                reject_if: ->(attributes) { attributes["description"].blank? }

  before_validation :assign_default_dates, on: :create
  before_validation :normalize_attributes

  validates :number, presence: true, uniqueness: true
  validates :issued_on, :due_on, presence: true
  validates :status, inclusion: { in: STATUSES }
  validate :due_on_after_issued_on
  validate :must_have_invoice_lines

  scope :recent, -> { order(issued_on: :desc, id: :desc) }
  scope :overdue, -> { where(status: "sent").where("due_on < ?", Date.current) }

  def draft?
    status == "draft"
  end

  def sent?
    status == "sent"
  end

  def paid?
    status == "paid"
  end

  def overdue?
    sent? && due_on.present? && due_on < Date.current
  end

  def display_status
    overdue? ? "overdue" : status
  end

  def total_ht
    invoice_lines.sum { |line| line.amount_ht }.round(2)
  end

  def total_vat
    invoice_lines.sum { |line| line.vat_amount }.round(2)
  end

  def total_ttc
    (total_ht + total_vat).round(2)
  end

  private

  def assign_default_dates
    self.issued_on ||= Date.current
    self.due_on ||= issued_on + 30
  end

  def normalize_attributes
    self.number = number.to_s.strip
    self.status = status.to_s.presence || "draft"
  end

  def due_on_after_issued_on
    return if issued_on.blank? || due_on.blank?
    return if due_on >= issued_on

    errors.add(:due_on, "doit être postérieure à la date d'émission")
  end

  def must_have_invoice_lines
    return if invoice_lines.reject(&:marked_for_destruction?).any?

    errors.add(:base, "Ajoutez au moins une ligne de facture.")
  end
end
