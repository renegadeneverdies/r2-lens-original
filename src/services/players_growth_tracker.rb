# frozen_string_literal: true

module Services
  class PlayersGrowthTracker
    class << self
      def call(scores)
        scores.each_with_object({}) do |(job, _), result|
          result[job] = {}
          players = Player.where(job: job)
          players.each { |player| result[job][player.name] = Services::PlayerGrowthTracker.call(player) }
        end
      end
    end
  end
end
