class Front::AlertsController < Front::BaseController
  before_action :load_alert, only: [:show, :edit, :update, :destroy, :process_alert]
  # before_action :require_front_user, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  # before_action :validate_current_front_user, only: [:show, :edit, :update, :destroy]

  def index
    @alerts = Alert.order_by_recent.page(params[:page]).per(10)
  end

  def show; end

  # def new
  #   @alert = Alert.new(front_user: current_front_user)
  # end

  # def create
  #   @alert = Alert.new(alert_params)
  #   @alert.front_user = current_front_user

  #   if @alert.save
  #     Notifications::OnNewAlertNotificationService.perform(@alert)
  #     HiPrometheus::Metrics.counter_increment(:num_alerts, { user: current_front_user.id })
  #     redirect_to [:front, @alert], notice: t("controllers.alerts.create.success")
  #   else
  #     flash.now[:alert] = t("controllers.alerts.create.error")
  #     render action: :new
  #   end
  # end

  # def edit; end

  # def update
  #   if @alert.update(alert_params)
  #     redirect_to [:front, @alert], notice: t("controllers.alerts.update.success")
  #   else
  #     flash.now[:alert] = t("controllers.alerts.update.error")
  #     render action: :edit
  #   end
  # end

  def destroy
    @alert.destroy
    redirect_to :front_alerts, notice: t("controllers.alerts.destroy.success")
  end

  def process_alert
    @alert.process
    redirect_to front_alert_path(@alert), notice: t("controllers.alerts.send.success")
  end

  protected

  # def alert_params
  #   params.require(:alert).permit(:front_user_id, :title, :body, :tag_list, :pic)
  # end

  private

  def load_alert
    @alert = Alert.find(params[:id])
  end

  # def validate_current_front_user
  #   if @alert.front_user != current_front_user
  #     redirect_to [:front, @alert], alert: t("controllers.front.access_not_authorized")
  #     false
  #   end
  # end
end
