require 'sqlite3'
require 'pry'

class Player
  def initialize
    @db = SQLite3::Database.new("db/r2lens.sqlite")
  end

  def create_table
    sql = <<~SQL
      CREATE TABLE IF NOT EXISTS players
        (
          id INTEGER PRIMARY KEY,
          Name TEXT,
          Level INTEGER,
          Percent FLOAT,
          Guild TEXT,
          Deleted BOOLEAN,
          created_at DATETIME CURRENT_TIMESTAMP
        )
    SQL
    @db.execute(sql)
  end

  def self.finalize(db)
    puts "a"
    db.close
  end
end

binding.pry
