puts ">>>> Loading Langchain::Tool::Chart..."

module Langchain::Tool
  class Chart < Base
    #
    # Generates charts from the data
    #
    # Gem requirements:
    #     gem "chartkick"
    #
    # Usage:
    #     chart = Langchain::Tool::Chart.new()
    #
    NAME = "chart"
    ANNOTATIONS_PATH = Langchain.root.join("#{__dir__}/#{NAME}.json").to_path

    # @return [Chart] Chart object
    def initialize()
    end

    # Chart Tool: Returns the received data
    #
    # @param data [Array] Array of arrays "key, value"
    # @return [Array] the data
    def create_line_chart(data:)
      data
    end

    # Chart Tool: Returns the received data
    #
    # @param data [Array] Array of hashes like '{name: <serie_name>, data: [[<value_label_1>, <data_1>], ...]'
    # @return [Array] the data
    def create_column_chart(data:)
      data
    end
  end
end
