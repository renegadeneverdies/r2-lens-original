# frozen_string_literal: true

require_relative "../src/models/level"

environment = ENV["APP_ENV"]&.to_sym || :development
Mongoid.load!("config/mongoid.yml", environment)

levels = JSON.parse(File.read("db/levels.json"))["levels"]
levels.each { |lvl| Level.create(number: lvl["ELevel"], exp: lvl["EExp"]) }
