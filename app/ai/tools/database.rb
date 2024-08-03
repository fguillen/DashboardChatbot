require "sequel"

# Inspired in: https://github.com/dghirardo/langchainrb/blob/5cd81647caf02a0520cd210db9fbbbb52fec4a44/lib/langchain/tool/database.rb
class Tools::Database < AI::Tool

  def tool_description_path
    "#{__dir__}/database.json"
  end

  def initialize(connection_string:)
    puts ">>>> Database.initialize(#{connection_string})"
    @connection_string = connection_string
  end

  def list_tables
    connection do |db|
      db.tables
    end
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

    tables =
      connection do |db|
        db.tables
      end

    schema = ""
    tables.each do |table|
      describe_table(table, schema)
    end

    schema
  end

  def describe_table(table, schema)
    schema << "CREATE TABLE #{table}(\n"

    columns =
      connection do |db|
        db.schema(table)
      end

    primary_key_columns = []
    primary_key_column_count = columns.count { |column| column[1][:primary_key] == true }

    columns.each do |column|
      schema << "#{column[0]} #{column[1][:type]}"
      if column[1][:primary_key] == true
        schema << " PRIMARY KEY" if primary_key_column_count == 1
      else
        primary_key_columns << column[0]
      end
      schema << ",\n" unless column == columns.last && primary_key_column_count == 1
    end
    if primary_key_column_count > 1
      schema << "PRIMARY KEY (#{primary_key_columns.join(",")})"
    end

    foreign_keys =
      connection do |db|
        db.foreign_key_list(table)
      end

    foreign_keys.each do |fk|
      schema << ",\n" if fk == foreign_keys.first
      schema << "FOREIGN KEY (#{fk[:columns][0]}) REFERENCES #{fk[:table]}(#{fk[:key][0]})"
      schema << ",\n" unless fk == foreign_keys.last
    end
    schema << ");\n"
  end

  def execute(input:)
    puts ">>>> Database.execute(#{input})"

    connection do |db|
      db[input].to_a
    end

  rescue Sequel::DatabaseError => e
    Langchain.logger.error(e.message, for: self.class)
  end

  private

  def connection(&block)
    db = Sequel.connect(@connection_string)
    result = block.call(db)
    db.disconnect
    result
  end
end
