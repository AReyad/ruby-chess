class Queen < Piece
  DIRECTIONS = %i[north north_east east
                  south_east south south_west
                  west north_west].freeze
end
