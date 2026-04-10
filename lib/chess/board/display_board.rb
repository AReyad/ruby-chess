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

    def display_board(board)
      board_colors = [LIGHT_SQUARE, DARK_SQUARE]
      board.each.with_index do |row, index|
        print row_labels(index)
        row.each do |square|
          display_square(board_colors[0], square, board_colors)
        end
        rotate_colors(board_colors)
      end
    end

    def display_square(color, value, colors)
      # changes the background of each board square, and replaces nil with EMPTY_SQUARE and prints it
      print background(color, value || EMPTY_SQUARE)
      colors.rotate!
    end

    def rotate_colors(colors)
      colors.rotate!
      puts ''
    end

    def highlight_position(board, pos)
      row = pos[0]
      col = pos[1]
      square = board[row][col]
      color = Palette.color('green')
      return board[row][col] = highlight(color, GREEN_CIRCLE, square.symbol_for_highlight) unless square.nil?

      board[row][col] = foreground(color, GREEN_CIRCLE)
    end

    def highlight_display(positions)
      board_clone = clone(game_board)
      positions.each { |position| highlight_position(board_clone, position) }
      display(board_clone)
    end

    def display_moves_right
      print "#{colorize_rights('Enpassent', fen.enpassent)} |  "
      print "#{colorize_rights('Castling', fen.castling_rights)}\n\n"
    end
  end
end
