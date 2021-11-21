class Admin::ImpersonationsController < Admin::BaseController
  before_action :require_admin_user

  def create
    front_user = FrontUser.find(impersonation_params[:front_user_id])
    FrontSession.create(front_user)

    redirect_to front_root_path, notice: t("controllers.impersonations.create.success")
  end

  protected

  def impersonation_params
    params.permit(:front_user_id)
  end
end
