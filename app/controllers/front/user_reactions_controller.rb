class Front::UserReactionsController < Front::BaseController
  before_action :require_front_user
  before_action :load_message, only: [:create, :destroy]
  before_action :load_user_reaction, only: [:destroy]

  def index
    @user_reactions = current_front_user.user_reactions.order_by_recent.page(params[:page]).per(10)
  end

  def create
    @user_reaction = @message.build_user_reaction(user_reaction_params)

    if @user_reaction.save
      if @user_reaction.positive?
        UserFavoriteCreatorJob.perform_later(user_reaction: @user_reaction)
      end

      respond_to do |format|
        format.html { redirect_to front_conversation_path(@message.conversation), notice: t("controllers.user_reactions.create.success") }
        format.turbo_stream
      end
    else
      redirect_to front_conversation_path(@message.conversation), alert: t("controllers.user_reactions.create.error")
    end
  end

  def destroy
    if @user_reaction.destroy
      @message.reload
      respond_to do |format|
        format.html { redirect_to front_conversation_path(@message.conversation), notice: t("controllers.user_reactions.destroy.success") }
        format.turbo_stream
      end
    else
      redirect_to front_conversation_path(@message.conversation), alert: t("controllers.user_reactions.destroy.error")
    end
  end

  def destroy_from_index
    @user_reaction = current_front_user.user_reactions.find(params[:id])

    if @user_reaction.destroy
      respond_to do |format|
        format.html { redirect_to front_user_reactions_path, notice: t("controllers.user_reactions.destroy.success") }
        format.turbo_stream
      end
    else
      redirect_to front_user_reactions_path, alert: t("controllers.user_reactions.destroy.error")
    end
  end

  private

  def user_reaction_params
    params.require(:user_reaction).permit(:explanation, :kind)
  end

  def load_message
    @message = current_front_user.messages.find(params[:message_id])
  end

  def load_user_reaction
    @user_reaction = @message.user_reaction
  end
end
