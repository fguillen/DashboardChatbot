class UserFavorites::NeighborsFinder < Service
  DISTANCE_METHOD = "cosine"
  DISTANCE_THRESHOLD = 0.5
  LIMIT_NEIGHBORS = 2

  def perform(user_prompt:)
    prompt_embeddings = UserFavorites::GenerateEmbeddings.perform(user_prompt)
    neighbors = filtered_neighbors(prompt_embeddings)
    neighbors
  end

  private

  def filtered_neighbors(target_prompt_embedding)
    UserFavorite
      .nearest_neighbors(:prompt_embedding, target_prompt_embedding, distance: DISTANCE_METHOD)
      .select { |n| n.neighbor_distance <= DISTANCE_THRESHOLD }
      .first(LIMIT_NEIGHBORS)
  end
end
