class Admin::UserReactionsController < Admin::BaseController
  before_action :require_admin_user

  def index
    @user_reactions = UserReaction.order_by_recent.page(params[:page]).per(50)
  end
end
