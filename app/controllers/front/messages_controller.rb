class Front::MessagesController < Front::BaseController
  before_action :require_front_user
  before_action :load_conversation, only: [:create]
  before_action :load_message, only: [:show]

  # after_action :confirm_last_model_answer, only: [:create]

  def show
  end

  def create
    @message = Message.new(message_params)
    @message.conversation = @conversation

    if @message.valid?
      Conversation::ProcessUserMessageService.perform(
        conversation: @conversation,
        role: @message.role,
        content: @message.content,
        model: @message.model
      )

      Conversation::ConfirmLastModelAnswer.perform(conversation: @conversation)

      # Notifications::OnNewMessageNotificationService.perform(@message)
      HiPrometheus::Metrics.counter_increment(:num_messages, { user: current_front_user.id })

      respond_to do |format|
        format.html { redirect_to [:front, @conversation], notice: t("controllers.messages.create.success") }
        format.turbo_stream
      end
    else
      flash.now[:alert] = t("controllers.messages.create.error")
      render template: "front/conversations/show"
    end
  end

  protected

  def message_params
    params.require(:message).permit(:role, :content, :model)
  end

  private

  def load_conversation
    @conversation = current_front_user.conversations.find(params[:conversation_id])
  end

  def load_message
    @message = Message.find(params[:id])
  end

  # def confirm_last_model_answer
  #   Conversation::ConfirmLastModelAnswer.perform(conversation: @conversation)
  # end
end
