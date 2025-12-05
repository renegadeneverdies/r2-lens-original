# frozen_string_literal: true

require "pry"
require_relative "./src/tracker"
require_relative "./src/scraper"

Mongoid.load!("./config/mongoid.yml", :development)

scraper = Scraper.new
tracker = Tracker.new(characters: scraper.fetch_characters, guilds: scraper.fetch_guilds)
tracker.transform_score
