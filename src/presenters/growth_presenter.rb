# frozen_string_literal: true

require "pry"

module Presenters
  class GrowthPresenter
    class << self
      def present(growth)
        @max_name_width = 15
        @max_score_width = 8
        @buffer = @max_name_width + @max_score_width * 3 + 13

        result = []

        growth.each do |job, players|
          headers(result, job)
          contents(result, players)
          result << ""
        end

        result.join("\n")
      end

      private

      def headers(result, job)
        result << job.upcase
        result << "=" * @buffer

        header = "| #{'Персонаж'.ljust(@max_name_width)} |"
        header << " #{'Уровень'.ljust(@max_score_width)} |"
        header << " #{'Процент'.ljust(@max_score_width)} |"
        header << " #{'Прирост'.ljust(@max_score_width)} |"
        result << header

        result << "-" * @buffer
      end

      def contents(result, players)
        players.each do |player|
          name = player[0].to_s
          level = player[1][:level].to_s
          percent = format("%.3f", player[1][:percent])
          percent_growth = format("%.3f", player[1][:percent_growth])

          row = "| #{name.ljust(@max_name_width)} |"
          row << " #{level.rjust(@max_score_width)} |"
          row << " #{percent.rjust(@max_score_width)} |"
          row << " #{percent_growth.rjust(@max_score_width)} |"
          result << row
        end
      end
    end
  end
end

# pp Presenters::GrowthPresenter.present(data)
