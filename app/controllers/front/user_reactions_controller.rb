class Front::UserReactionsController < Front::BaseController
  before_action :require_front_user
  before_action :load_user_reaction, only: [:create]

  def create
    @user_reaction = UserReaction.new(user_reaction_params)

    if @user_reaction.save
      respond_to do |format|
        format.html { redirect_to [:front, @message.conversation], notice: t("controllers.user_reactions.create.success") }
        format.turbo_stream
      end
    else
      redirect_to [:front, @message.conversation], alert: t("controllers.user_reactions.create.error")
    end
  end

  private

  def user_reaction_params
    params.require(:user_reaction).permit(:message_id, :explanation, :kind)
  end

  def load_message
    @message = current_front_user.messages.find(params[:message_id])
  end
end
