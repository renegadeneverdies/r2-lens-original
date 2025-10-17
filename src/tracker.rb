require_relative 'scraper'
require_relative '../models/player'
require 'sqlite3'

class Tracker
  JOB_MAPPING = {
    "0" => "knight",
    "1" => "ranger",
    "2" => "mage",
    "3" => "assassin",
    "4" => "summoner"
  }
  LEVEL_COEF = 153
  SCORE_COEF = 50000

  attr_accessor :characters

  def initialize(characters:, guilds:)
    @characters = characters.transform_keys { |key| key = JOB_MAPPING[key] }
    @guilds = guilds
  end
  
  def transform_score
    xp_for_level = xp_requirements

    @characters.transform_values do |job|
      job[..10].each do |player|
        guild_id = player["mGuildNo"].to_s
        player["mGuildName"] = @guilds.dig(guild_id, "mGuildName")
        player["mClass"] = JOB_MAPPING[player["mClass"].to_s] if JOB_MAPPING.keys.include?(player["mClass"].to_s)
        player["mLevel"] = player["mPoint"] / LEVEL_COEF
        player["mPercent"] = (player["mScore"].to_f / (xp_for_level[player["mLevel"]] / SCORE_COEF) * 100).round(3)
      end
    end
  end

  private

  def xp_requirements
    db = SQLite3::Database.new("db/r2lens.sqlite")
    exp_table = db.execute("SELECT ELevel, EExp FROM levels")
    db.close

    exp_table.each_with_object({}) do |pair, memo|
      memo[pair.first] = pair.last
    end
  end
end

scraper = Scraper.new
tracker = Tracker.new(characters: scraper.fetch_characters, guilds: scraper.fetch_guilds)
