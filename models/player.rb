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
          Class TEXT,
          Level INTEGER,
          Percent FLOAT,
          Guild TEXT,
          Deleted BOOLEAN,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP
        )
    SQL
    @db.execute(sql)
  end

  def self.finalize(db)
    db.close
  end

  def create(player:)
    return false unless valid?(player:)

    sql = <<~SQL
      INSERT INTO players (Name, Class, Level, Percent, Guild, Deleted)
      VALUES (?, ?, ?, ?, ?, ?)
    SQL
    @db.execute(sql, [player["mName"], player["mClass"], player["mLevel"], player["mPercent"], player["mGuildName"], 0])
  end

  def valid?(player:)
    player.slice("mName", "mClass", "mGuildName", "mLevel", "mPercent").values.none?(nil)
  end
end
