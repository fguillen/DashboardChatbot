require "sequel"

# Inspired in: https://github.com/dghirardo/langchainrb/blob/5cd81647caf02a0520cd210db9fbbbb52fec4a44/lib/langchain/tool/database.rb
class Tools::Database < AI::Tool
  attr_reader :db

  def tool_description_path
    "#{__dir__}/database.json"
  end

  def initialize(connection_string:)
    puts ">>>> Database.initialize(#{connection_string})"

    @db = Sequel.connect(connection_string)
  end

  def list_tables
    db.tables
  end

  def describe_tables(tables:)
    schema = ""
    tables.split(",").each do |table|
      describe_table(table, schema)
    end
    schema
  end

  def dump_schema
    puts ">>>> Database.dump_schema"

    schema = ""
    db.tables.each do |table|
      describe_table(table, schema)
    end
    schema
  end

  def describe_table(table, schema)
    primary_key_columns = []
    primary_key_column_count = db.schema(table).count { |column| column[1][:primary_key] == true }

    schema << "CREATE TABLE #{table}(\n"
    db.schema(table).each do |column|
      schema << "#{column[0]} #{column[1][:type]}"
      if column[1][:primary_key] == true
        schema << " PRIMARY KEY" if primary_key_column_count == 1
      else
        primary_key_columns << column[0]
      end
      schema << ",\n" unless column == db.schema(table).last && primary_key_column_count == 1
    end
    if primary_key_column_count > 1
      schema << "PRIMARY KEY (#{primary_key_columns.join(",")})"
    end
    db.foreign_key_list(table).each do |fk|
      schema << ",\n" if fk == db.foreign_key_list(table).first
      schema << "FOREIGN KEY (#{fk[:columns][0]}) REFERENCES #{fk[:table]}(#{fk[:key][0]})"
      schema << ",\n" unless fk == db.foreign_key_list(table).last
    end
    schema << ");\n"
  end

  def execute(input:)
    puts ">>>> Database.execute(#{input})"

    db[input].to_a
  rescue Sequel::DatabaseError => e
    Langchain.logger.error(e.message, for: self.class)
  end
end
