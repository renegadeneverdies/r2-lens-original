# frozen_string_literal: true

require "pry"
require "require_all"

require_all "src/services"
require_relative "./src/tracker"
require_relative "./src/scraper"

Mongoid.load!("./config/mongoid.yml", :development)

scraper = Scraper.new
tracker = Tracker.new(characters: scraper.fetch_characters, guilds: scraper.fetch_guilds)
scores = tracker.transform_score
previous_scores = Services::PreviousScoresLookup.call(scores)
tracker.commit(scores)
movements = Services::PlayerMovementTracker.call(previous_scores, scores)
growth = Services::PlayersGrowthTracker.call(scores)
binding.pry
