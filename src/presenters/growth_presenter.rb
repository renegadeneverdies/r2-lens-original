# frozen_string_literal: true

module Presenters
  class GrowthPresenter
    class << self
      def present(growth)
        @max_name_width = 13
        @max_level_width = 3
        @max_score_width = 7
        @max_growth_width = 4
        @buffer = @max_name_width + @max_level_width + @max_score_width + @max_growth_width + 18

        growth.each_with_object([]) do |(job, players), result|
          job_rating = ["<pre>"]
          job_rating << headers(job)
          job_rating << contents(players)
          job_rating << "</pre>"
          result << job_rating.join("\n")
        end
      end

      private

      def headers(job)
        result = [job.upcase]
        result << "-" * @buffer

        header = " #{'Персонаж'.ljust(@max_name_width)} |"
        header << " #{'LVL'.ljust(@max_level_width)} |"
        header << " #{'Процент'.ljust(@max_score_width)} |"
        header << " #{'Рост 1д/7д'.ljust(@max_growth_width)}"
        result << header

        result << "-" * @buffer
      end

      def contents(players)
        players.each_with_object([]) do |player, result|
          name = player[0].to_s
          level = player[1][:level].to_s
          percent = format("%.3f", player[1][:percent])
          percent_growth_day = format("%.1f", player[1][:percent_growth_day])
          percent_growth_week = format("%.1f", player[1][:percent_growth_week])

          row = " #{name.ljust(@max_name_width)} |"
          row << " #{level.rjust(@max_level_width)} |"
          row << " #{percent.rjust(@max_score_width)} |"
          row << " #{percent_growth_day.ljust(@max_growth_width)} / #{percent_growth_week}"
          result << row
        end
      end
    end
  end
end
