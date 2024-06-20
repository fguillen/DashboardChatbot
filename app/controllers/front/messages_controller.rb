class Front::MessagesController < Front::BaseController
  before_action :require_front_user
  before_action :load_conversation

  def create
    @message = Message.new(message_params)
    @message.conversation = @conversation

    if @message.valid?
      @messages = Conversation::ProcessUserMessageService.perform(@conversation, @message.role, @message.content)

      # Notifications::OnNewMessageNotificationService.perform(@message)
      HiPrometheus::Metrics.counter_increment(:num_messages, { user: current_front_user.id })

      respond_to do |format|
        format.html { redirect_to [:front, @conversation], notice: t("controllers.messages.create.success") }
        format.turbo_stream
      end
    else
      puts ">>>> message.errors: #{@message.errors.full_messages}"
      flash.now[:alert] = t("controllers.messages.create.error")
      render template: "front/conversations/show"
    end
  end

  protected

  def message_params
    params.require(:message).permit(:role, :content)
  end

  private

  def load_conversation
    @conversation = current_front_user.conversations.find(params[:conversation_id])
  end
end
