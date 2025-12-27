# frozen_string_literal: true

module Services
  class PreviousScoresLookup
    class << self
      def call(ratings)
        ratings.each_with_object({}) do |(job, _), result|
          result[job] = Player.where(job: job).order_by(position: :asc).map(&:serialize)
          return ratings if result[job].blank?
        end
      end
    end
  end
end
