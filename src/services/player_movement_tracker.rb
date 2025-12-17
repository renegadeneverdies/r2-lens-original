# frozen_string_literal: true

module Services
  class PlayerMovementTracker
    class << self
      def call(ratings_then, ratings_now)
        ratings_then.each_with_object({}) do |(job, _), result|
          result[job] = analyze_roster(ratings_then[job], ratings_now[job])
        end
      end

      private

      def analyze_roster(roster_then, roster_now)
        roster_now.each_with_object([]).with_index do |(player, result), index|
          if find_old_player(roster_then, roster_now, player["mName"], index) != [player["mName"], index]
            result << [roster_then[index], roster_now[index]]
          end
        end
      end

      def find_old_player(roster_then, roster_now, name, index, window: 3)
        min_position = (index - window).positive? ? index - window : 0
        max_position = index + window
        pool_then = roster_then[min_position..max_position].map { _1["mName"] }
        return [name, index] if pool_then.include?(name)

        pool_now = roster_now[min_position..max_position].map { _1["mName"] }
        other_names = pool_now.reject { _1 == name }
        old_name = (pool_then - other_names).first
        old_index = pool_then.index(old_name)
        [old_name, old_index]
      end
    end
  end
end
