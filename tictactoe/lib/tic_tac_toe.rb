class Game
  require_relative "board"
  require_relative "player"

  attr_accessor :player1, :player2, :players, :board, :game, :curr_player

  def initialize

#    @corners = ["1","3","7","9"]
#    @checkmate_move = nil
#    @final_move = nil
    @winner = false
    @board = Board.new
  end

  def choose_game
    puts "How many players? (0,1 or 2)"
    response = ""
    while !["0","1","2"].include? response
      response = gets.chomp
      if response == "2"
        versus("What is the name of player 1?", nil, "X", \
               "What is the name of player 2?", nil, "O")
        @game = 2
      elsif response == "1"
        versus("What is your name?", nil, "X",\
                      nil, "Computer", "O")
        @game = 1
      elsif response == "0"
        versus(nil, "Computer", "X",\
               nil, "Computer", "O")
        @game = 0
      else
        puts "Invalid response. Please try again."
      end
    end
    @players = [@player1, @player2]
  end

  def versus(text1, name1, symbol1, text2, name2, symbol2)
    @player1 = Player.new(text1, name1, symbol1)
    @player2 = Player.new(text2, name2, symbol2)
  end


  def start_game
    puts "Game starts. Coin Tossed."
    @curr_player = @players[rand(2)]
    #@initial_player_index = 1 #testing: force initial to be computer
    puts "#{@curr_player.name} goes first."
    @curr_player.name
  end

  def running
    @turn = 1
    #@board.print_board(@players)
    unless draw?
      while @winner == false
        #set_up_turn
        @board.print_board(@players)
        whose_round

        if @board.check_winning(@curr_player)
          puts "#{@curr_player.name} wins!"
          @winner = true
        else
          @curr_player = choose_player
          puts "#{@curr_player.name}'s turn."
        end

        @turn += 1
      end
    else
      puts "Tie; no one wins"
    end

    puts "Another game?"
  end

  def draw?
    @turn > 9
  end

  def choose_player
    @curr_player == @player1 ? @player2 : @player1
  end

  def whose_round
    if @game == 2
      players_round
    elsif @game == 1
      players_round if @curr_player_index == 0
      computers_round if @curr_player_index == 1
    else
      computers_round
    end
  end


#  def set_up_turn
#    @symbol_for_player = @curr_player_index  % 2 == 0 ? "X" : "O"
#    puts "#{@players[@curr_player_index].name}'s turn."

#    @avail_corners = @corners - @taken_tiles
#  end

  def players_round
    input = take_input
    remember_input(input)
  end


  def take_input
    taken_tiles = @player1.moves + @player2.moves

    input = ""
    is_valid = false
    while !is_valid
      puts "choose a tile(1-9) to place #{@curr_player.symbol}."
      input = gets.chomp
      is_valid = @board.check_tile(input, taken_tiles)
    end
  end

  def remember_input(input)
    @curr_player.moves << input
  end


  def reset
    @player1.moves = []
    @player2.moves = []
#    @checkmate_move = nil
#    @final_move = nil
    @winner = false
  end
#end

#######
#COMPUTER AI

#class Game
  def computers_round
    @played = false

    if @turn == 1
      random_tile #which will choose a corner automatically
    end

    [@curr_player_index,((@curr_player_index + 1) % 2)].each do |i|
      if @played == false
        check_2in3(@avail_tiles, @players[i].moves) #first checks if computer can already win, then check if need to prevent player from winning
        choose_tile(@any_winning[0]) if @any_winning.length > 0
      end
    end

    if @played == false #runs if no one can immediately win in this round
      if @final_move == nil
        final_move(@avail_tiles, @players[@curr_player_index].moves, nil)
      end

      if @final_move != nil #final move is now determined; note, this is not 'else' of the prior 'if'
        choose_tile(@final_move)
      else #if final move not determined, run strategy
        if @turn == 3 #the strategy would not be useful except in turn 1
          winning_strategy
          choose_tile(@checkmate_move) if @checkmate_move != nil
        end
      end
    end

    if @played == false #is still no move taken
      #in the event that Player goes first, and chooses a corner
      if @turn == 2 and @avail_corners.length == 3
        choose_tile("5") #choose the centre
      #in the event that Computer goes first, and Player chooses centre
      elsif @turn == 3 and @taken_tiles.include? "5"
        player_chooses_centre_in_turn2
      elsif @turn == 4
        if @avail_corners.length == 3 #in the event that Player goes first but avoids choosing corners
          choose_tile("5") #choose the centre
        elsif @avail_corners.length == 2
          if @players[@curr_player_index].moves.include? "5" #i.e. Player took 2 diagonal corners; Computer took centre
            #choose a tile that is not a corner
            non_corners = ["2","4","6","8"]
            random_non_corner = non_corners[rand(4)]
            choose_tile(random_non_corner)
          else #i.e. Player intially takes centre, Computer then takes corner, Player then takes diagonal corner
            random_tile #chooses a remaining corner
          end
        else
          if @avail_corners.length == 2 and !@taken_tiles.include? "5" #i.e. Player initial takes non-corner, Computer takes a corner, Player then takes a corner
            choose_tile("5") #choose the centre
          end
        end
      else
        random_tile
      end
    end
  end


  def check_2in3(avail_tiles, player_moves) #i=0 checks computer's winning method; i=prevents player from winning
    @any_winning = []
    @winnning_patterns.each do |pattern|
      if pattern.count {|x| player_moves.include? x} == 2
         missing_tile = pattern.select {|x| !(player_moves.include? x)}
         missing_tile = missing_tile.join #change array to string
         if avail_tiles.include? missing_tile
           @any_winning << missing_tile
         end
      end
    end
  end


  def random_tile #go for the corners first
    @random_tile = ""
    if @avail_corners.length > 0
      @random_tile = @avail_corners[rand(@avail_corners.length)]
    else
      @random_tile = @avail_tiles[rand(@avail_tiles.length)]
    end
    choose_tile(@random_tile)
  end

  def player_chooses_centre_in_turn2
    taken_corner_arr = @taken_tiles.select {|i| @corners.include? i}
    if ["1", "9"].include? taken_corner_arr.join
      @random_tile = (["1", "9"]- taken_corner_arr).join #if 1, then 9; visa versa
    else
      @random_tile = (["3", "7"]- taken_corner_arr).join #if 3, then 7, visa versa
    end
    choose_tile(@random_tile)
  end

  def choose_tile(i)
    @players[@curr_player_index].moves << i
    puts "Computer chooses tile #{i}"
    @played = true
  end



  def winning_strategy
    @avail_tiles.each do |i|
      #duplicates the current moves for both players
      test_player_moves = @players[(@curr_player_index + 1) % 2].moves.clone
      test_computer_moves = @players[@curr_player_index].moves.clone
      test_avail_tiles = @avail_tiles.clone

      #Computer's turn: test if a move is taken, what happens
      test_computer_moves << i
      test_avail_tiles.delete(i)
      check_2in3(test_avail_tiles,test_computer_moves)

      #Player's turn: check if a 2 in 3 is created by the test move
      if @any_winning.length > 0 #player is forced to block the computer
        test_player_moves << @any_winning.join
        test_avail_tiles -= @any_winning
        check_2in3(test_avail_tiles, test_player_moves)
        if @any_winning.length ==  0 #if the player's move forces Computer to make a move ,the strategy fails
          final_move(test_avail_tiles, test_computer_moves, i)
        end
      end
      break if @checkmate_move != nil
    end
  end

  def final_move(avail_tiles, computer_moves, i)
    avail_tiles.each do |j| #Computer's turn
      computer_moves << j
      check_2in3(avail_tiles,computer_moves)
      if @any_winning.length >= 2 #see if by taking a move, two 2 in 3s can be created
        @checkmate_move = i
        @final_move = j
        break
      end
      computer_moves.delete(j) #remember to remove what is added
    end
  end

end

###
#play = true
#a = Game.new
#a.choose_game

#while play == true
#  a.start_game
#  a.running
#  a.reset
#  puts "\n\nPress any key to start new game"
#  b = gets.chomp
#end
