class Admin::ConversationsController < Admin::BaseController
  before_action :require_admin_user
  before_action :load_conversation, only: [:show, :edit, :update, :destroy]

  def index
    @conversations = Conversation.order_by_recent.page(params[:page]).per(50)
  end

  def show; end

  def destroy
    @conversation.destroy
    redirect_to :admin_conversations, notice: t("controllers.conversations.destroy.success")
  end

  protected

  def conversation_params
    params.require(:conversation).permit(:front_user_id, :title, :body)
  end

  private

  def load_conversation
    @conversation = Conversation.find(params[:id])
  end
end
