require "test_helper"

class ClientTest < ActiveSupport::TestCase
  test "requires a name" do
    client = Client.new(email: "contact@example.com")

    assert_not client.valid?
    assert_includes client.errors[:name], "can't be blank"
  end

  test "normalizes email and optional fields" do
    client = Client.create!(name: "  Ada Lovelace  ", email: " ADA@EXAMPLE.COM ", company: "  ")

    assert_equal "Ada Lovelace", client.name
    assert_equal "ada@example.com", client.email
    assert_nil client.company
  end

  test "uses the company as display name when available" do
    assert_equal "Acme Studio", clients(:acme).display_name
    assert_equal "Studio Lumen", clients(:studio_lumen).display_name
  end

  test "destroys associated invoices" do
    client = clients(:studio_lumen)

    assert_difference -> { Invoice.count }, -client.invoices.count do
      client.destroy!
    end
  end
end
