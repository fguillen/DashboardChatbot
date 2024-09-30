class Api::Front::ConversationsController < Api::Front::ApiController
  before_action :load_conversation, only: [:show]

  def index
    conversations = current_front_user.conversations.no_from_alert.order_by_recent.page(params[:page]).per(30)
    render json: { conversations: conversations.map(&:to_hash_for_api) }.to_json, status: :ok
  end

  def show
    @message = @conversation.messages.new(role: Message.roles[:user])
    @message.model = @conversation.messages.in_order.last&.model || "openai/gpt-4-turbo"
  end

  def new
    @conversation = Conversation.new
  end

  def create
    @conversation = current_front_user.conversations.new(conversation_params)

    if @conversation.save
      # Notifications::OnNewConversationNotificationService.perform(@conversation)
      HiPrometheus::Metrics.counter_increment(:num_conversations, { user: current_front_user.id })
      redirect_to [:front, @conversation], notice: t("controllers.conversations.create.success")
    else
      flash.now[:alert] = t("controllers.conversations.create.error")
      render action: :new
    end
  end

  private

  def load_conversation
    @conversation = current_front_user.conversations.find(params[:id])
  end
end
