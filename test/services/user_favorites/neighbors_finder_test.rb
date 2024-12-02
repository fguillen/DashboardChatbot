require "test_helper"

class UserFavorites::NeighborsFinderTest < ActiveSupport::TestCase
  def test_distance
    original_sentence = "How many sales in euros I have had in 2024?"

    similar_sentences = [
      "How many sales in euros I have had in 2024?",
      "How many sales in euros I have had in 2023?",
      "How many sales I have had in 2024?",
      "Look in 2024 and tell me how many sales in euros I have had",
    ]

    slightly_similar_sentences = [
      "How many clients I have?",
      "Give me all the products of the family 'celulosa'",
    ]

    no_similar_sentences = [
      "Hi, how are you?",
      "Generate an alert for this",
    ]

    distance_methods = [
      "euclidean",
      "cosine",
      "taxicab",
      # "chebyshev",
    ]

    original_sentence_embeddings = UserFavorites::GenerateEmbeddings.perform(original_sentence)
    user_favorite = FactoryBot.create(:user_favorite, prompt_embedding: original_sentence_embeddings)

    distance_methods.each do |distance_method|
      puts "Method: #{distance_method}"
      puts "Similar sentences: "
      similar_sentences.each do |sentence|
        distance_sentence(sentence:, distance_method:)
      end

      puts "Slightly similar sentences: "
      slightly_similar_sentences.each do |sentence|
        distance_sentence(sentence:, distance_method:)
      end

      puts "No similar sentences: "
      no_similar_sentences.each do |sentence|
        distance_sentence(sentence:, distance_method:)
      end

      puts
    end

    # no_similar_sentences.each do |sentence|
    #   sentence_embeddings = UserFavorites::GenerateEmbeddings.perform(sentence)
    #   distance = UserFavorites::ExamplesCreator.perform(user_favorite:, sentence_embeddings:).neighbo_distance

    #   puts ">>>> sentence: #{sentence}, distance: #{distance}"
    # end
  end

  def test_perform
    user_favorite_1 = generate_user_favorite("How many sales in euros I have had in 2023?")
    user_favorite_2 = generate_user_favorite("How many sales I have had in 2024?")
    user_favorite_3 = generate_user_favorite("Hi, how are you?")

    result = UserFavorites::NeighborsFinder.perform(user_prompt: "How many sales in euros I have had in 2024?")
    assert_primary_keys([user_favorite_1, user_favorite_2], result)
  end

  private

  def distance_sentence(sentence:, distance_method:)
    sentence_embeddings = UserFavorites::GenerateEmbeddings.perform(sentence)
    neighbor = UserFavorite.nearest_neighbors(:prompt_embedding, sentence_embeddings, distance: distance_method).first
    distance = neighbor.neighbor_distance

    puts ">>>> sentence: #{sentence}, distance: #{distance}"
  end

  def generate_user_favorite(prompt)
    prompt_embedding = UserFavorites::GenerateEmbeddings.perform(prompt)
    FactoryBot.create(:user_favorite, prompt_embedding:)
  end
end
