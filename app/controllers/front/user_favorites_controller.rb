class Front::UserFavoritesController < Front::BaseController
  before_action :require_front_user

  def index
    @user_favorites = current_front_user.user_favorites.order_by_recent.page(params[:page]).per(10)
  end

  def destroy
    @user_favorite = current_front_user.user_favorites.find(params[:id])

    if @user_favorite.destroy
      respond_to do |format|
        format.html { redirect_to front_user_favorites_path, notice: t("controllers.user_favorites.destroy.success") }
        format.turbo_stream
      end
    else
      redirect_to front_user_favorites_path, alert: t("controllers.user_favorites.destroy.error")
    end
  end
end
