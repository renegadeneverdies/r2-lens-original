# frozen_string_literal: true

module Services
  class PlayerGrowthTracker
    def self.call(player)
      last_record = player.exp_records.last(2).last
      first_record = player.exp_records.last(2).first

      level_growth = last_record["level"] - first_record["level"]
      percent_growth = (level_growth * 100 + last_record["percent"] - first_record["percent"]).round(3)
      { level_growth:, percent_growth:, level: last_record["level"], percent: last_record["percent"] }
    end
  end
end
