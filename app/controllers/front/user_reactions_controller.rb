class Front::UserReactionsController < Front::BaseController
  before_action :require_front_user
  before_action :load_message, only: [:create]

  def create
    @user_reaction = @message.user_reactions.build(user_reaction_params)

    if @user_reaction.save
      respond_to do |format|
        format.html { redirect_to front_conversation_path(@message.conversation), notice: t("controllers.user_reactions.create.success") }
        format.turbo_stream
      end
    else
      redirect_to front_conversation_path(@message.conversation), alert: t("controllers.user_reactions.create.error")
    end
  end

  private

  def user_reaction_params
    params.require(:user_reaction).permit(:explanation, :kind)
  end

  def load_message
    @message = current_front_user.messages.find(params[:message_id])
  end
end
