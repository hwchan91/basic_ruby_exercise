class Player
  attr_accessor :name, :moves, :symbol

  def initialize(text = nil, name, symbol)
    puts text if !text.nil?
    if name.nil?
      @name = gets.chomp
    else
      @name = name
    end
    @moves = []
    @symbol = symbol
  end

#  def gets_name
#    gets.chomp
#  end
end
