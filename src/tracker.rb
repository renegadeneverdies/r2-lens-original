# frozen_string_literal: true

require_relative "scraper"
require_relative "../models/player"
require "sqlite3"

class Tracker
  JOB_MAPPING = {
    "0" => "knight",
    "1" => "ranger",
    "2" => "mage",
    "3" => "assassin",
    "4" => "summoner",
    "knight" => "knight",
    "ranger" => "ranger",
    "mage" => "mage",
    "assassin" => "assassin",
    "summoner" => "summoner"
  }.freeze
  LEVEL_COEF = 153
  SCORE_COEF = 50_000

  @@db = SQLite3::Database.new("db/r2lens.sqlite")

  attr_accessor :characters

  def initialize(characters:, guilds:)
    @characters = characters.transform_keys { |key| JOB_MAPPING[key] }
    @guilds = guilds
  end

  def transform_score
    @characters.transform_values do |job|
      job.each do |player|
        player["mGuildName"] = @guilds.dig(player["mGuildNo"].to_s, "mGuildName")
        player["mClass"] = JOB_MAPPING[player["mClass"].to_s]
        player["mLevel"] = player["mPoint"] / LEVEL_COEF
        player["mPercent"] = score_to_percent(player["mScore"].to_f, player["mLevel"])
      end
    end
  end

  def commit(scores)
    scores.each_value do |job|
      job.each_with_index do |player_attrs, index|
        Player.create_or_find_by_from_scraper(player_attrs.merge({ "current_position" => index + 1 }))
      end
    end
  end

  private

  def xp_requirements
    exp_table = @@db.execute("SELECT ELevel, EExp FROM levels")

    exp_table.each_with_object({}) do |pair, memo|
      memo[pair.first] = pair.last
    end
  end

  def score_to_percent(score, level)
    (score / (xp_requirements[level] / SCORE_COEF) * 100).round(3)
  end
end

# job = gets
# scraper = Scraper.new
# tracker = Tracker.new(characters: scraper.fetch_characters, guilds: scraper.fetch_guilds)
# puts tracker.transform_score[job]
