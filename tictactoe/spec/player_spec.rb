require "player"

describe Player do

  let (:player) { Player.new("What is your name?", "Test Name", "X") }

  context "initialize" do


    it "sets name" do
      expect(player.name).to eql("Test Name")
    end

    it "creates moves as an empty array" do
      expect(player.moves).to eql([])
    end
  end
end
