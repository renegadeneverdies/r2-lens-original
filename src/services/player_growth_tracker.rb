# frozen_string_literal: true

module Services
  class PlayerGrowthTracker
    def self.call(player)
      last_record = player.exp_records.last(2).last
      first_record = player.exp_records.last(2).first

      level = last_record["level"] - first_record["level"]
      percent_now = level * 100 + last_record["percent"]
      percent = (percent_now - first_record["percent"]).round(3)
      { level:, percent: }
    end
  end
end
