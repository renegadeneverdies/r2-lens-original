# frozen_string_literal: true

require "require_all"

require_all "src"

Mongoid.load!("#{__dir__}/config/mongoid.yml", :development)

scraper = Fetching::Scraper.new
tracker = Fetching::Tracker.new(characters: scraper.fetch_characters, guilds: scraper.fetch_guilds)
scores = tracker.transform_score
tracker.commit(scores)
previous_scores = Services::PreviousScoresLookup.call(scores)
Services::PlayerMovementTracker.call(previous_scores, scores)
growth = Services::PlayersGrowthTracker.call(scores)
pres = Presenters::GrowthPresenter.present(growth)
bot = Adapters::R2lensBot.new(token: ENV["BOT_TOKEN"], chat_id: ENV["CHAT_ID"])
pres.each { |job_list| bot.post(job_list) }
