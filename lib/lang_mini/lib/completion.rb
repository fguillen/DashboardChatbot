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

class LangMini::Completion
  attr_reader :data

  def initialize(data)
    @data = LangMini::Utils.symbolize_keys(data)
  end

  def message
    @data[:choices][0][:message]
  end

  def tool_calls
    @data[:choices][0][:message][:tool_calls]
  end

  def tools?
    tool_calls.present?
  end

  def model
    @data[:model]
  end
end
