require "csv"

class Data::CsvToDbService < Service
  def perform(csv_path, force: false)
    table_name = get_table_name(csv_path)

    if !force && connection.table_exists?(table_name)
      puts "Table '#{table_name}' already exists."
      return
    end

    create_table(csv_path, table_name)
    insert_data(csv_path, table_name)
  end

  private

  def connection
    @connection ||= Sequel.connect(APP_CONFIG["dashboard_db_connection"])
  end

  def get_table_name(csv_path)
    File.basename(csv_path, File.extname(csv_path)).downcase
  end

  def create_table(csv_path, table_name)
    csv = CSV.read(csv_path, headers: true)

    connection.create_table(table_name) do
      csv.headers.each do |header|
        column(Data::CsvToDbService.extract_header_name(header), Data::CsvToDbService.extract_header_type(header))
      end
    end
  end

  def insert_data(csv_path, table_name)
    csv = CSV.open(csv_path, headers: true)
    csv.header_convert { |header, field_info| Data::CsvToDbService.extract_header_name(header) }
    csv.read.map(&:to_hash).each do |row|
      puts ">>>> Inserting row: #{row}"
      connection.from(table_name).insert(row)
    end
  end

  def self.extract_header_name(header)
    header.scan(/[\w\s]+/).flatten.first.strip
  end

  def self.extract_header_type(header)
    header.scan(/\((.*)\)/).flatten.first.strip
  end
end
