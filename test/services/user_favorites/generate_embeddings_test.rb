require "test_helper"

class UserFavorites::GenerateEmbeddingsTest < ActiveSupport::TestCase
  def test_generate_embeddings
    sentences = ["Sentence 1", "Sentence 2"]
    embeddings = UserFavorites::GenerateEmbeddings.perform(sentences)

    assert_equal(2, embeddings.size)
    assert_equal(384, embeddings[0].size)

    # write_fixture("user_favorites/sentences_embeddings.json", embeddings.to_s)
    assert_equal(read_fixture("user_favorites/sentences_embeddings.json"), embeddings.to_s)
  end

  def test_generate_embeddings_with_only_one_sentence
    sentences = "Sentence 1"
    embeddings = UserFavorites::GenerateEmbeddings.perform(sentences)

    assert_equal(384, embeddings.size)

    # write_fixture("user_favorites/sentences_embeddings_one_sentence.json", embeddings.to_s)
    assert_equal(read_fixture("user_favorites/sentences_embeddings_one_sentence.json"), embeddings.to_s)
  end
end
