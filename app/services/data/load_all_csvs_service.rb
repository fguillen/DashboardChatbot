class Data::LoadAllCsvsService < Service
  def perform(force: false)
    files = Dir.entries(sources_path).select { |f| File.file? File.join(sources_path, f) }
    puts ">>>> files: #{files}"

    files.each do |file|
      Data::CsvToDbService.perform("#{sources_path}/#{file}", force: force)
    end
  end

  private

  def sources_path
    "#{Rails.root}/csv_db/sources"
  end
end
