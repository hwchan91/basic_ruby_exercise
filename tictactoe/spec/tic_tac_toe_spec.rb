#require "rspec_helper"
require_relative "../lib/tic_tac_toe"

describe Game do
  before do
    @game = Game.new
    @game.player1 = Player.new(nil,"A","X")
    @game.player2 = Player.new(nil,"B","O")
    @game.players = [@game.player1, @game.player2]
    @game.game = 2
  end

  describe ".start_game" do
    it "chooses random player to start" do
      first = []
      10.times do
        first << @game.start_game
      end
      expect(first.all? {|x| x == first[0]}).to be false
    end
  end

  describe ".choose_player" do
    it "switches player from 1 to 2" do
      @game.curr_player = @game.player1
      expect(@game.choose_player).to eql(@game.player2)
    end

    it "switches player from 2 to 1" do
      @game.curr_player = @game.player2
      expect(@game.choose_player).to eql(@game.player1)
    end
  end

  describe ".players_round" do
    it "put player's move" do
      @game.player1.moves = ["1","2"]
      @game.curr_player = @game.player1
      allow(@game).to receive(:take_input).and_return("5")
      @game.players_round
      expect(@game.player1.moves).to match_array(["1","2","5"])
    end
  end

  describe ".whose_round" do
    it "runs ,players_round when @game == 2" do
      @game.game = 2

      @game.player1.moves = ["1","2"]
      @game.curr_player = @game.player1
      allow(@game).to receive(:take_input).and_return("5")
      @game.whose_round
      expect(@game.player1.moves).to match_array(["1","2","5"])
    end
  end


end
