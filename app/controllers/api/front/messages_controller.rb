class Api::Front::MessagesController < Api::Front::ApiController
  before_action :load_conversation, only: [:create]

  def create
    message = Message.new(message_params)
    message.conversation = @conversation

    if message.valid?
      messages =
        Conversation::ProcessUserMessageService.perform(
          conversation: @conversation,
          role: message.role,
          content: message.content,
          model: message.model
        )

      render json: { messages: messages.map(&:to_hash) }.to_json, status: :ok
    else
      render json: { errors: message.errors.messages }.to_json, status: :unprocessable_entity
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
end
