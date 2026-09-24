class InvoiceLine < ApplicationRecord
  belongs_to :invoice

  before_validation :normalize_attributes

  validates :description, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
  validates :vat_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def amount_ht
    ((quantity || 0) * (unit_price || 0)).round(2)
  end

  def vat_amount
    (amount_ht * (vat_rate || 0) / 100).round(2)
  end

  def amount_ttc
    (amount_ht + vat_amount).round(2)
  end

  private

  def normalize_attributes
    self.description = description.to_s.strip
  end
end
