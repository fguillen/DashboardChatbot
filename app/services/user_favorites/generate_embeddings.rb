class UserFavorites::GenerateEmbeddings < Service
  def perform(sentences)
    model = Informers.pipeline("embedding", "sentence-transformers/all-MiniLM-L6-v2")
    model.(sentences)
  end
end
