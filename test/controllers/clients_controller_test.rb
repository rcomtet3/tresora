require "test_helper"

class ClientsControllerTest < ActionDispatch::IntegrationTest
  test "lists clients" do
    get clients_path

    assert_response :success
    assert_select "h1", "Clients"
    assert_select "td", text: /Acme Studio/
  end

  test "creates a client" do
    assert_difference -> { Client.count }, 1 do
      post clients_path, params: {
        client: {
          name: "Nouvelle société",
          email: "contact@nouvelle-societe.fr",
          company: "Nouvelle Société"
        }
      }
    end

    assert_redirected_to clients_path
    follow_redirect!
    assert_select ".flash", /client a été ajouté/
  end

  test "renders the form when a client is invalid" do
    assert_no_difference -> { Client.count } do
      post clients_path, params: { client: { name: "" } }
    end

    assert_response :unprocessable_entity
    assert_select ".form-errors"
  end

  test "updates a client" do
    patch client_path(clients(:acme)), params: { client: { company: "Acme Conseil" } }

    assert_redirected_to clients_path
    assert_equal "Acme Conseil", clients(:acme).reload.company
  end
end
