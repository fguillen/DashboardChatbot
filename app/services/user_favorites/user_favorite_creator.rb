class UserFavorites::UserFavoriteCreator < Service
  def perform(user_reaction:)
    prompt = user_reaction.original_prompt
    messages_until_rection = user_reaction.message.conversation.messages_until(user_reaction.message)
    model_mental_process = UserFavorites::ModelMentalProcessGenerator.perform(messages: messages_until_rection)
    prompt_embedding = UserFavorites::GenerateEmbeddings.perform(prompt)

    UserFavorite.create!(
      prompt:,
      model_mental_process:,
      prompt_embedding:,
      user_reaction:,
    )
  end
end
