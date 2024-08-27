class JsonSerializerWithSymbolKeys
  def self.dump(hash)
    hash
  end

  def self.load(hash)
    JSON.parse(JSON.generate(hash), symbolize_names: true)
  end
end
