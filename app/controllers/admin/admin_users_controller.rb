class Admin::AdminUsersController < Admin::BaseController
  before_action :require_admin_user, :except => [:reset_password, :reset_password_submit]
  before_action :load_admin_user, :only => [:show, :edit, :update, :destroy]

  def index
    @admin_users = AdminUser.order_by_recent
  end

  def show
  end

  def new
    @admin_user = AdminUser.new
  end

  def create
    @admin_user = AdminUser.new(admin_user_params)
    if @admin_user.save
      redirect_to [:admin, @admin_user], :notice => t("controllers.admin_users.create.success")
    else
      flash.now[:alert] = t("controllers.admin_users.create.error")
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @admin_user.update_attributes(admin_user_params)
      redirect_to [:admin, @admin_user], :notice  => t("controllers.admin_users.update.success")
    else
      flash.now[:alert] = t("controllers.admin_users.update.error")
      render :action => :edit
    end
  end

  def destroy
    @admin_user.destroy
    redirect_to :admin_admin_users, :notice => t("controllers.admin_users.destroy.success")
  end

  def reset_password
    @admin_user = AdminUser.find_using_perishable_token!(params[:reset_password_code], 1.week)

    render :reset_password, :layout => "admin/base_basic"
  end

  def reset_password_submit
    @admin_user = AdminUser.find_using_perishable_token!(params[:reset_password_code], 1.week)

    if @admin_user.update_attributes(admin_user_params)
      AdminSession.create(@admin_user)
      flash[:notice] = t("controllers.admin_users.reset_password.success")
      redirect_back_or_default admin_root_path
    else
      flash.now[:alert] = t("controllers.admin_users.reset_password.error")
      render :reset_password, :layout => "admin/base_basic"
    end
  end

protected

  def admin_user_params
    params.require(:admin_user).permit(:name, :email, :password, :password_confirmation, :uuid)
  end

private

  def load_admin_user
    @admin_user = AdminUser.find(params[:id])
  end
end
