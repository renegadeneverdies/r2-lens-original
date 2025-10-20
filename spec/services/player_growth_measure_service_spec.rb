require_relative "../../services/player_growth_measure_service"
require_relative "../../models/player"

RSpec.describe Services::PlayerGrowthMeasureService do
  subject { service.call(player_then, player_now) }

  let(:service) { described_class }
  let(:attributes) do
    {
      "mName" => "player1",
      "mClass" => "knight",
      "mGuildName" => "void"
    }
  end
  let(:player_then) do
    xp = {
      "mLevel" => 80,
      "mPercent" => 50,
    }
    Player.new(xp.merge(attributes))
  end
  let(:player_now) do
    xp = {
      "mLevel" => 80,
      "mPercent" => 60,
    }
    Player.new(xp.merge(attributes))
  end

  context "when level growth is zero" do
    it { is_expected.to eq({ level: 0, percent: 10 }) }
  end

  context "when level growth is 1" do
    let(:player_now) do
      xp = {
      "mLevel" => 81,
      "mPercent" => 10,
    }
    Player.new(xp.merge(attributes))
    end

    it "carries resulting percent over from the next level" do
      expect(subject).to eq({ level: 1, percent: 60 })
    end
  end
end