class ClientsController < ApplicationController
  before_action :set_client, only: %i[edit update destroy]

  def index
    @clients = Client.order(:name)
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to clients_path, notice: "Le client a été ajouté."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @client.update(client_params)
      redirect_to clients_path, notice: "Les informations du client ont été mises à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy!
    redirect_to clients_path, notice: "Le client a été supprimé.", status: :see_other
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :email, :company, :address)
  end
end
