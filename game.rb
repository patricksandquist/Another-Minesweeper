require_relative 'board.rb'

class Game
  LAYOUTS = {
    :small => { :grid_size => 9, :num_bombs => 10 },
    :medium => { :grid_size => 16, :num_bombs => 40 },
    :large => { :grid_size => 32, :num_bombs => 160 } # whoa.
  }

  def initialize(size)
    params = LAYOUTS[size]
    @board = Board.new(params[:grid_size], params[:num_bombs])
    play_game
  end

  private

  def play_game
    until @board.over?
      puts @board
      move = get_move
      make_move(move)
    end

    puts @board

    if @board.won?
      puts "You won!"
    else
      puts "You lost!"
    end
  end

  def get_move
    puts "Do you want to [f]lag or [e]xplore a tile?"
    action = gets.chomp.downcase[0]

    puts "What position on the grid?"
    pos = gets.chomp.split(",").map { |e| e.to_i }

    {:action => action, :pos => pos}
  end

  def make_move(move)
    case move[:action]
    when "f"
      @board[move[:pos]].toggle_flag
    when "e"
      @board[move[:pos]].reveal
    end
  end
end

if $PROGRAM_NAME == __FILE__
  MinesweeperGame.new(:small).play
end
