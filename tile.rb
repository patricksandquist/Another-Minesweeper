class Tile
  DELTAS = [
    [-1, 0],
    [-1, 1],
    [0, 1],
    [1, 1],
    [1, 0],
    [1, -1],
    [0, -1],
    [-1, -1]
  ]

  def initialize(board, pos)
    @board, @pos = board, pos
    @flagged, @bombed, @explored = false
  end

  def flagged?
    @flagged
  end

  def bombed?
    @bombed
  end

  def explored?
    @explored
  end

  def plant_bomb
    @bombed = true
  end

  def toggle_flag
    @flagged = !@flagged
  end

  def reveal
    # Reveal tile and return string
    # Ignore if flagged or already revealed
    return if flagged? || explored?

    @explored = true
    if bombed?
      "B"
    else
      nbc = neighbor_bomb_count
      # Reveal all neighboring tiles if nbc is zero
      if nbc.zero?
        neighbors.each { |neighbor| neighbor.reveal }
      end

      nbc.to_s
    end
  end

  def render
    return "F" if flagged?
    return "_" unless explored?
    return "B" if bombed?

    nbc = neighbor_bomb_count
    nbc.zero? ? " " : nbc.to_s
  end

  def neighbors
    # Return the neighboring tiles
    neighboring_positions = DELTAS.select do |delta|
      new_pos = [@pos[0] + delta[0], @pos[1] + delta[1]]
      @board.in_range?(new_pos)
    end

    neighboring_positions.map { |pos| @board[pos] }
  end

  def neighbor_bomb_count
    # Return the number of neighboring bombs
    neighbors.select(:&bombed?).count
  end
end
