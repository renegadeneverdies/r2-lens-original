# frozen_string_literal: true

require_relative "../../../src/models/player"

RSpec.describe Player do
  let!(:player) do
    described_class.create({
                             name: "player1",
                             job: "knight",
                             guild: "void",
                             current_position: 1,
                             exp_records: [first_record, second_record]
                           })
  end
  let(:first_record) do
    {
      "date" => 2.days.ago.to_date.to_s,
      "level" => 80,
      "percent" => 50
    }
  end
  let(:second_record) do
    {
      "date" => Date.yesterday.to_s,
      "level" => 80,
      "percent" => 60
    }
  end

  describe "#add_exp_record" do
    subject(:add_exp_record) { player.add_exp_record(data) }

    let(:data) do
      {
        "mLevel" => 80,
        "mPercent" => 70
      }
    end
    let(:third_record) do
      {
        "date" => Date.today.to_s,
        "level" => 80,
        "percent" => 70
      }
    end

    context "when adding new date" do
      it "appends a record" do
        expect { add_exp_record }.to(change { player.exp_records.size })
      end
    end

    context "when adding date of the last existing record" do
      let(:second_record) do
        {
          "date" => Date.today.to_s,
          "level" => 80,
          "percent" => 60
        }
      end

      it "overwrites the record" do
        expect { add_exp_record }.not_to(change { player.exp_records.size })
      end
    end

    it "sets data as the last record" do
      add_exp_record
      expect(player.exp_records.last).to eq(third_record)
    end
  end
end
