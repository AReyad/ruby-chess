module Chess
  class Bishop < Piece
    DIRECTIONS = %i[north_east south_east
                    north_west south_west].freeze
  end
end
