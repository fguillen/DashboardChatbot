class Admin::ClientsController < Admin::BaseController
  before_action :require_admin_user
  before_action :load_client, only: [:show, :edit, :update, :destroy, :front_users, :log_book_events]

  def index
    @clients = Client.order_by_recent.page(params[:page]).per(10)
  end

  def show; end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to [:admin, @client], notice: t("controllers.clients.create.success")
    else
      flash.now[:alert] = t("controllers.clients.create.error")
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @client.update(client_params)
      redirect_to [:admin, @client], notice: t("controllers.clients.update.success")
    else
      flash.now[:alert] = t("controllers.clients.update.error")
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    redirect_to :admin_clients, notice: t("controllers.clients.destroy.success")
  end

  def front_users
    @front_users = @client.front_users
  end

  def log_book_events
    @log_book_events = @client.log_book_events.by_recent
  end

  protected

  def client_params
    params.require(:client).permit(:name, :agent_instructions, :db_connection, :api_key, :default_model)
  end

  private

  def load_client
    @client = Client.find(params[:id])
  end
end
