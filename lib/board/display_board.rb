module DisplayBoard
  EMPTY_SQUARE = '   '.freeze
  COLUMNS_LABELS = "   #{('a'..'h').to_a.join('  ')}\n".freeze
  BOARD_SIZE = 8
  LIGHT_SQUARE = '235;204;176'.freeze
  DARK_SQUARE = '163;82;78'.freeze

  def display_board(board)
    board_colors = [LIGHT_SQUARE, DARK_SQUARE]
    board.each.with_index do |row, index|
      # prints each row index in reverse
      print "#{BOARD_SIZE - index} "
      row.each do |square|
        # changes the background of each board square, and replaces nil with EMPTY_SQUARE and prints it
        print Colorize.background(board_colors[0], square || EMPTY_SQUARE)
        board_colors.rotate!
      end
      board_colors.rotate!
      puts ''
    end
  end

  def highlight_position(board, pos)
    row = pos[0]
    col = pos[1]
    square = board[row][col]
    return board[row][col] = Colorize.highlight('15;90;32', "\u2022", square.symbol_for_highlight) unless square.nil?

    board[row][col] = Colorize.foreground('15;90;32', "\u2022")
  end

  def highlight_display(positions)
    puts ''
    board_clone = Marshal.load(Marshal.dump(board))
    positions.each { |position| highlight_position(board_clone, position) }
    display_board(board_clone)
    puts COLUMNS_LABELS
  end
end
