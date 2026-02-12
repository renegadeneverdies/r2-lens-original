# frozen_string_literal: true

require_relative "../../../src/services/player_growth_tracker"
require_relative "../../../src/models/player"

RSpec.describe Services::PlayerGrowthTracker do
  subject(:growth) { service.call(player) }

  let(:service) { described_class }
  let(:player) do
    Player.new({
                 name: "player1",
                 job: "knight",
                 guild: "void",
                 position: 1,
                 exp_records: [week_ago_record, yesterday_record, last_record]
               })
  end
  let(:week_ago_record) do
    {
      "level" => 80,
      "percent" => 20
    }
  end

  context "when level growth is zero" do
    let(:yesterday_record) do
      {
        "level" => 80,
        "percent" => 50
      }
    end
    let(:last_record) do
      {
        "level" => 80,
        "percent" => 60
      }
    end

    it {
      expect(growth).to eq({ level: 80, percent: 60, level_growth_day: 0, percent_growth_day: 10, level_growth_week: 0,
                             percent_growth_week: 40 })
    }
  end

  context "when level growth is 1" do
    let(:yesterday_record) do
      {
        "level" => 80,
        "percent" => 90
      }
    end
    let(:last_record) do
      {
        "level" => 81,
        "percent" => 10
      }
    end

    it "carries resulting percent over from the next level" do
      expect(growth).to eq({ level: 81, percent: 10, level_growth_day: 1, percent_growth_day: 20, level_growth_week: 1,
                             percent_growth_week: 90 })
    end
  end
end
