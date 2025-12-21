# frozen_string_literal: true

require "mongoid"

class Player
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :job, type: String
  field :guild, type: String
  field :current_position, type: Integer
  field :exp_records, type: Array, default: []

  index({ name: 1 }, { unique: true, background: true })

  validates :name, presence: true, uniqueness: true

  def self.create_or_find_by_from_scraper(attrs)
    data = attrs.slice("mLevel", "mPercent")

    player = Player.find_by(name: attrs["mName"])
    if player.blank?
      player = Player.create(
        {
          name: attrs["mName"],
          job: attrs["mClass"],
          guild: attrs["mGuildName"],
          current_position: attrs["current_position"]
        }
      )
    end

    player.add_exp_record(data)
  end

  def add_exp_record(data)
    record = {
      "date" => Date.today.to_s,
      "level" => data["mLevel"],
      "percent" => data["mPercent"]
    }

    records = exp_records.filter { |r| r["date"] != record["date"] }
    records << record
    update(exp_records: records.first(7))
  end

  def serialize
    {
      "mName" => name,
      "mClass" => job,
      "mGuildName" => guild,
      "mLevel" => exp_records.last["level"],
      "mPercent" => exp_records.last["percent"]
    }
  end
end
