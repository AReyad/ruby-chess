module Chess
  module DisplayBoard
    include Colorize
    EMPTY_SQUARE = '   '.freeze
    COLUMNS_LABELS = "   #{('a'..'h').to_a.join('  ')}\n".freeze
    BOARD_SIZE = 8
    LIGHT_SQUARE = Palette.color('red').freeze
    DARK_SQUARE = Palette.color('reddish_brown').freeze
    GREEN_CIRCLE = "\u2022".freeze

    def row_labels(index)
      # prints each row index in reverse
      "#{BOARD_SIZE - index} "
    end

    def display_board(board, position)
      board_colors = [LIGHT_SQUARE, DARK_SQUARE]
      board.each_with_index do |row, row_index|
        print row_labels(row_index)
        row.each_with_index do |square, square_index|
          next highlight_square(square, board_colors) if position.include?([row_index, square_index])

          display_square(board_colors, square)
        end
        rotate_colors(board_colors)
      end
    end

    def display_square(colors, value)
      # changes the background of each board square, and replaces nil with EMPTY_SQUARE and prints it
      print background(colors[0], value || EMPTY_SQUARE)
      colors.rotate!
    end

    def rotate_colors(colors)
      colors.rotate!
      puts ''
    end

    def highlight_square(square, colors)
      color = Palette.color('green')
      print background(colors[0], highlight(color, GREEN_CIRCLE, square.symbol_for_highlight)) unless square.nil?
      print background(colors[0], foreground(color, GREEN_CIRCLE)) if square.nil?
      colors.rotate!
    end

    def display_moves_right
      print "#{colorize_rights('Enpassent', fen.enpassent)} |  "
      print "#{colorize_rights('Castling', fen.castling_rights)}\n\n"
    end
  end
end
