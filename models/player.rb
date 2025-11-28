# frozen_string_literal: true

require "sqlite3"

class Player
  include Comparable
  attr_reader :name, :job, :level, :percent, :guild_name

  @@db = SQLite3::Database.new("db/r2lens.sqlite")

  def initialize(attributes = {})
    @name = attributes["mName"]
    @job = attributes["mClass"]
    @level = attributes["mLevel"]
    @percent = attributes["mPercent"]
    @guild_name = attributes["mGuildName"]
    @deleted = 0
  end

  def <=>(other)
    return nil unless other.is_a?(Player)

    (level <=> other.level).zero? ? (percent <=> other.percent) : (level <=> other.level)
  end

  def self.create_table
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

  def self.create(attributes)
    return false unless valid?(attributes)

    sql = <<~SQL
      INSERT INTO players (Name, Class, Level, Percent, Guild, Deleted)
      VALUES (?, ?, ?, ?, ?, ?)
    SQL
    @db.execute(sql, [player["mName"], player["mClass"], player["mLevel"], player["mPercent"], player["mGuildName"], 0])
  end

  def self.valid?(attributes)
    attributes.slice("mName", "mClass", "mGuildName", "mLevel", "mPercent").values.none?(nil)
  end
end
