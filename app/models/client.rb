class Client < ApplicationRecord
  has_many :invoices, dependent: :destroy

  before_validation :normalize_attributes

  validates :name, presence: true, length: { maximum: 120 }
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/ }, allow_blank: true

  def display_name
    company.presence || name
  end

  private

  def normalize_attributes
    self.name = name.to_s.strip
    self.email = email.to_s.strip.downcase.presence
    self.company = company.to_s.strip.presence
    self.address = address.to_s.strip.presence
  end
end
