require_relative 'tile.rb'

class Board
  def initialize(grid_size, num_bombs)
    @grid_size = grid_size
    make_grid!
    plant_bombs!(num_bombs)
  end

  def in_range?(pos)
    pos.all? { |coord| (0...@grid_size).include?(coord) }
  end

  def won?
    @grid.flatten.all? do |tile|
      !tile.bombed? == tile.explored?
    end
  end

  def lost?
    @grid.flatten.any? { |tile| tile.bombed? && tile.explored? }
  end

  def over?
    won? || lost?
  end

  def [](pos)
    # Syntactic sugar for accessing tiles
    row, col = pos
    @grid[row][col]
  end

  def to_s
    # Override the default to_s method
    output = ""

    @grid.each do |row|
      row.each do |tile|
        output += tile.render
      end
      output += "\n"
    end

    output
  end

  private

  def make_grid!
    # Make a new 2D square array for our minefield
    @grid = Array.new(@grid_size) do |i|
      Array.new(@grid_size) do |j|
        Tile.new(self, [i, j])
      end
    end
  end

  def plant_bombs!(num_bombs)
    until num_bombs.zero?
      pos = [rand(@grid_size), rand(@grid_size)]
      tile = self[pos]

      # Skip if there is already a bomb there
      next if tile.bombed?

      num_bombs -= 1
      tile.plant_bomb
    end
  end
end
