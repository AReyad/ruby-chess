module Chess
  module Promotion
    WHITE_LAST_ROW = 0
    BLACK_LAST_ROW = 7

    def promotable?(position, color)
      return black_promotable?(position) if color == 'black'

      white_promotable?(position)
    end

    def black_promotable?(position)
      position[0] == BLACK_LAST_ROW
    end

    def white_promotable?(position)
      position[0] == WHITE_LAST_ROW
    end

    def select_promotion(promotions)
      keys = promotions.keys

      display_promotions(keys)
      loop do
        selected_promotion = gets.chomp.to_i
        next CLI.invalid_promotion unless promotions[keys[selected_promotion]]

        return promotions[keys[selected_promotion]]
      end
    end

    def valid_promotion?(promotions, input)
      promotions[input]
    end

    def display_promotions(promotions)
      promotions.each_with_index { |key, index| puts "#{index}) #{key}" }
      print '=> Type the number of piece you want to promote your pawn into: '
    end

    def promotions(color)
      { 'Queen' => Queen.new(color), 'Rook' => Rook.new(color), 'Knight' => Knight.new(color),
        'Bishop' => Bishop.new(color) }
    end
  end
end
