class Board
  require_relative "player"

  @@winnning_patterns = [["1","2","3"], ["4","5","6"], ["7","8","9"], ["1","4","7"], ["2","5","8"],\
   ["3","6","9"], ["1","5","9"], ["3","5","7"]]
  @@valid_values = (1..9).map {|x| x.to_s}

  attr_accessor :board, :taken_tiles, :avail_tiles

  def initialize
    @board = (1..9).map {|x| x.to_s}
  end

  def print_board(players)
    #symbols = ["X", "O"]
    for i in (0..1)
      @board.map! {|slot| (players[i].moves.include? slot)? players[i].symbol : slot}
    end
    puts "\n\n"
    i=0
    for i in [0,3,6]
      puts " #{@board[i]}  |  #{@board[i+1]}  |  #{@board[i+2]}  "
      puts "----------------" if i < 6
    end
    puts "\n\n"
    @board

    #moved set_up_turn functions here
  end


  def check_tile(input, taken_tiles)

    if !@@valid_values.include? input
      puts "Invalid Response! Please type a number between 1-9"
      false
    elsif taken_tiles.include? input
      puts "The tile is already taken, please choose an empty tile"
      false
    else
      true
    end
  end


  def check_winning(player)
    @winner = false
    @@winnning_patterns.each do |pattern|
      @winner = true if pattern.all? {|x| player.moves.include? x}
    end
    @winner
  end

  def print_winners_name
    puts "#{player.name} wins!" if check_winning
  end

end
