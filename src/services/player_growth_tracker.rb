# frozen_string_literal: true

module Services
  class PlayerGrowthTracker
    class << self
      def call(player)
        last_record = player.exp_records.last(2).last
        yesterday_record = player.exp_records.last(2).first
        week_ago_record = player.exp_records.first

        {
          level_growth_day: last_record["level"] - yesterday_record["level"],
          percent_growth_day: percent_growth(yesterday_record, last_record),
          level_growth_week: last_record["level"] - week_ago_record["level"],
          percent_growth_week: percent_growth(week_ago_record, last_record),
          level: last_record["level"],
          percent: last_record["percent"]
        }
      end

      private

      def percent_growth(p_before, p_after)
        ((p_after["level"] - p_before["level"]) * 100 + p_after["percent"] - p_before["percent"]).round(1)
      end
    end
  end
end
