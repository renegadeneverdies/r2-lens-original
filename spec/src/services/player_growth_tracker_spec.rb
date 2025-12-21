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
                 current_position: 1,
                 exp_records: [first_record, last_record]
               })
  end
  let(:first_record) do
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

  context "when level growth is zero" do
    it { is_expected.to eq({ level: 0, percent: 10 }) }
  end

  context "when level growth is 1" do
    let(:last_record) do
      {
        "level" => 81,
        "percent" => 10
      }
    end

    it "carries resulting percent over from the next level" do
      expect(growth).to eq({ level: 1, percent: 60 })
    end
  end
end
