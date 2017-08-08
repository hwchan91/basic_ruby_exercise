require_relative "../lib/board"
require_relative "../lib/player"

describe Board do
  before do
    @board = Board.new
    @player1 = Player.new(nil, "Player 1", "X")
    @player2 = Player.new(nil, "Player 2", "O")
    @players = [@player1, @player2]
  end

#  let (:board) {Board.new}
#  let (:player1) {Player.new(nil, "Player 1")}



  describe "print board function" do
    context "intialize" do
      it "prints 1..9 at start of the game" do
        expect(@board.board).to match_array(["1","2","3","4","5","6","7","8","9"])
      end
    end


    context "players chosen some tiles" do
      it "prints chosen tiles" do
#        @player1 = Player.new(nil, "Player 1")
#        @player2 = Player.new(nil, "Player2")
        @player1.moves = ["1", "2"]
        @player2.moves = ["3", "4"]
#        board.instance_variable_set("@players", [player1, player2])
        expect(@board.print_board(@players)).to match_array(["X","X","O","O","5","6","7","8","9"])
      end
    end
  end


  describe ".check_tile" do
    it "should reject input outside 1..9" do
      expect(@board.check_tile("n", ["1","5","9"])).to be false
    end

    it "should reject input that is already chosen" do
      expect(@board.check_tile("5", ["1","5","9"])).to be false
    end

    it "should accept tiles that have not been chosen" do
      expect(@board.check_tile("4", ["1","5","9"])).to be true
    end
  end




  describe ".check_winning" do
    it "checks if someone wins" do
      @player1.moves = ["1", "2", "3"]
#      @player2.moves = ["5", "4"]
      @board.instance_variable_set("@curr_player_index", 0)
      expect(@board.check_winning(@player1)).to be true
    end

    it "checks if someone wins" do
      @player1.moves = ["1", "2", "4"]
#      @player2.moves = ["5", "3"]
      @board.instance_variable_set("@curr_player_index", 0)
      expect(@board.check_winning(@player1)).to be false
    end

    it "checks if someone wins" do
#      @player1.moves = ["5", "2"]
      @player2.moves = ["1", "4", "7", "9"]
      @board.instance_variable_set("@curr_player_index", 1)
      expect(@board.check_winning(@player2)).to be true
    end
  end
end
