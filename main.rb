# frozen_string_literal: true

require "pry"
require "require_all"

require_all "src/services"
require_all "src/fetching"

Mongoid.load!("./config/mongoid.yml", :development)

scraper = Fetching::Scraper.new
tracker = Fetching::Tracker.new(characters: scraper.fetch_characters, guilds: scraper.fetch_guilds)
scores = tracker.transform_score
tracker.commit(scores)
# previous_scores = Services::PreviousScoresLookup.call(scores)
# movements = Services::PlayerMovementTracker.call(previous_scores, scores)
# growth = Services::PlayersGrowthTracker.call(scores)
