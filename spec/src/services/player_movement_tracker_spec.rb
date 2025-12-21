# frozen_string_literal: true

require_relative "../../../src/services/player_movement_tracker"
require_relative "../../../src/models/player"

RSpec.describe Services::PlayerMovementTracker do
  subject { described_class.call(roster_then, roster_now) }

  let(:roster_then) do
    {
      "knight" => [
        { "mName" => "player1", "mGuildName" => "guild1" },
        { "mName" => "player2", "mGuildName" => "guild1" },
        { "mName" => "player3", "mGuildName" => "guild2" },
        { "mName" => "player4", "mGuildName" => "guild2" },
        { "mName" => "player5", "mGuildName" => "guild3" },
        { "mName" => "player6", "mGuildName" => "guild4" }
      ]
    }
  end

  context "when player changed name but remained on the same position" do
    let(:roster_now) do
      {
        "knight" => [
          { "mName" => "player1", "mGuildName" => "guild1" },
          { "mName" => "player2", "mGuildName" => "guild2" },
          { "mName" => "player7", "mGuildName" => "guild1" },
          { "mName" => "player4", "mGuildName" => "guild2" },
          { "mName" => "player5", "mGuildName" => "guild3" },
          { "mName" => "player6", "mGuildName" => "guild4" }
        ]
      }
    end
    let(:result) do
      {
        "knight" => [[{ "mName" => "player3", "mGuildName" => "guild2" },
                      { "mName" => "player7", "mGuildName" => "guild1" }]]
      }
    end

    it { is_expected.to eq(result) }
  end

  context "when player changed name and guild and moved to a new position" do
    let(:roster_now) do
      {
        "knight" => [
          { "mName" => "player1", "mGuildName" => "guild1" },
          { "mName" => "player2", "mGuildName" => "guild2" },
          { "mName" => "player8", "mGuildName" => "guild5" },
          { "mName" => "player4", "mGuildName" => "guild2" },
          { "mName" => "player9", "mGuildName" => "" },
          { "mName" => "player6", "mGuildName" => "guild4" }
        ]
      }
    end
    let(:result) do
      {
        "knight" => [
          [{ "mName" => "player3", "mGuildName" => "guild2" }, { "mName" => "player8", "mGuildName" => "guild5" }],
          [{ "mName" => "player5", "mGuildName" => "guild3" }, { "mName" => "player9", "mGuildName" => "" }]
        ]
      }
    end

    it { is_expected.to eq(result) }
  end
end
