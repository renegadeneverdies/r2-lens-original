# frozen_string_literal: true

require "require_all"

require_relative "scraper"
require_all "src/models"

module Fetching
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

    attr_accessor :characters

    def initialize(characters:, guilds:)
      @characters = characters.transform_keys { |key| JOB_MAPPING[key] }
      @guilds = guilds
      @xp_requirements = Level.all
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
          Player.create_or_find_by_from_scraper(player_attrs.merge({ "position" => index + 1 }))
        end
      end
    end

    private

    def score_to_percent(score, level)
      (score / (@xp_requirements.find_by(number: level).exp / SCORE_COEF) * 100).round(3)
    end
  end
end
