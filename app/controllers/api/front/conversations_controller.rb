class Api::Front::ConversationsController < Api::Front::ApiController
  before_action :load_conversation, only: [:show]

  def index
    conversations = current_front_user.conversations.no_from_alert.order_by_recent.page(params[:page]).per(30)
    render json: { conversations: conversations.map(&:to_hash_for_api) }.to_json, status: :ok
  end

  def show
    render json: { conversation: @conversation.to_hash }.to_json, status: :ok
  end

  def create
    @conversation = current_front_user.conversations.new(conversation_params)

    if @conversation.save
      render json: { conversation: @conversation.to_hash }.to_json, status: :ok
    else
      render json: { errors: @conversation.errors.messages }.to_json, status: :unprocessable_entity
    end
  end

  private

  def load_conversation
    @conversation = current_front_user.conversations.find(params[:id])
  end

  def conversation_params
    params.require(:conversation).permit(:title)
  end
end
