# {
#   "id": "gen-65tQ5SrtTo1B5WN73LTkn3c9DDal",
#   "model": "meta-llama/llama-3.1-8b-instruct:free",
#   "object": "chat.completion",
#   "created": 1722289059,
#   "choices": [
#     {
#       "index": 0,
#       "message": {
#         "role": "assistant",
#         "content": "The color of the sky can look different depending on the time of day and atmospheric conditions.\n\nDuring the day, when the sun is overhead, the sky typically appears blue. This is because the Earth's atmosphere scatters the sunlight in all directions, with shorter (blue) wavelengths being scattered more than longer (red) wavelengths. This phenomenon is known as Rayleigh scattering.\n\nHowever, the color of the sky can change under different conditions:\n\n* During sunrise and sunset, the sky can appear red, orange, pink, or purple due to the scattering of light by atmospheric particles.\n* On overcast days, the sky may appear gray or white due to the clouds blocking direct sunlight.\n* At night, the sky can appear dark, with stars and constellations visible due to the absence of direct sunlight.\n\nSo, to answer your question, the color of the sky is often blue, but it can change depending on the time of day and atmospheric conditions!"
#       },
#       "finish_reason": "stop",
#       "logprobs": null
#     }
#   ],
#   "usage": {
#     "prompt_tokens": 29,
#     "completion_tokens": 191,
#     "total_tokens": 220
#   }
# }

class AI::Message
  attr_reader :data, :raw

  def initialize(data:, raw: nil)
    @data = data
    @raw = raw
  end

  private_class_method :new

  def role
    @data&.dig(:role)
  end

  def content
    @data&.dig(:content)
  end

  def raw
    @raw
  end

  def tool_calls
    @raw&.dig("tool_calls")
  end

  def tool_call_id
    @data&.dig(:tool_call_id)
  end

  def model
    @raw&.dig("model")
  end

  def self.from_hash(hash)
    new(data: hash, raw: hash)
  end

  def self.from_completion(completion)
    data = completion.message
    raw = completion.raw

    new(data:, raw:)
  end

  def to_s
    raw
  end
end
