class Front::ConversationsController < Front::BaseController
  before_action :load_conversation, only: [:show, :update]
  before_action :require_front_user
  before_action :validate_current_front_user, only: [:show]

  def index
    @conversations = current_front_user.conversations.no_from_alert.order_by_recent.page(params[:page]).per(30)
  end

  def show
    @message = @conversation.messages.new(role: Message.roles[:user])
    @message.model = @conversation.messages.in_order.last&.model || "openai/gpt-4o-2024-11-20"

    respond_to do |format|
      format.html
      format.json { render json: @conversation.to_hash_raw, layout: false }
    end
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

  def update
    if @conversation.update(conversation_params)
      redirect_to front_conversations_path, notice: t("controllers.conversations.update.success")
    else
      flash.now[:alert] = t("controllers.conversations.update.error")
      render action: :edit
    end
  end

  protected

  def conversation_params
    params.require(:conversation).permit(:title)
  end

  private

  def load_conversation
    @conversation = Conversation.find(params[:id])
  end

  def validate_current_front_user
    if @conversation.front_user != current_front_user
      redirect_to [:front, @conversation], alert: t("controllers.front.access_not_authorized")
      false
    end
  end
end
