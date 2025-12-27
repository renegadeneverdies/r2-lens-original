# frozen_string_literal: true

module Services
  class PlayersGrowthTracker
    class << self
      def call(scores)
        scores.each_with_object({}) do |(job, _), result|
          result[job] = {}
          names = scores[job].map { _1["mName"] }
          players = Player.where(:name.in => names).order_by(position: :asc)
          players.each { |player| result[job][player.name] = Services::PlayerGrowthTracker.call(player) }
        end
      end
    end
  end
end
