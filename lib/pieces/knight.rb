class Knight < Piece
  DIRECTIONS = [%i[north north_east], %i[east north_east],
                %i[north north_west], %i[west north_west],
                %i[south south_east], %i[east south_east],
                %i[south south_west], %i[west south_west]].freeze
end
