module Chess
  module CLI
    module_function

    def turn(player)
      print "=> #{player.name}'s turn select a piece to move or type (exit) to quit: "
    end

    def invalid_selection(player, piece)
      return puts "=> Invalid selection, you can't select an empty tile!" if piece.nil?

      return no_safe_moves(piece) if player.color == piece.color

      different_color_piece(piece)
    end

    def invalid_incheck_selection(player, piece)
      return puts "=> Invalid selection, you can't select an empty tile!" if piece.nil?

      return puts "#{piece} can't defend king" if player.color == piece.color

      different_color_piece(piece)
    end

    def post_selection(moves)
      print "=> Pick a move from the following: (#{MoveConverter.convert_moves(moves)}) or type back to select another piece: "
    end

    def no_safe_moves(piece)
      puts "=> #{piece} can't make any safe moves, select another piece."
    end

    def different_color_piece(piece)
      puts "=> #{piece} is of a different color, select a piece with the same color as yours."
    end

    def king_in_check
      puts 'DANGEROUS! your king is under attack select a piece to defend the king or select the king and escape!'
      print '=> '
    end

    def invalid_destination(input)
      puts "=> #{MoveConverter.convert_move(input)} is not a possible move."
    end

    def invalid_input(input)
      puts "=> #{input} is invalid please enter a valid input."
      puts '=> Examples of some valid inputs a1, d4, h8.'
    end

    def save_confirmation
      system 'clear'
      print '=> Do you want to save the game? Y\n: '
    end

    def exited
      puts '=> Exited without saving!'
    end

    def saved
      puts 'Game saved successfully.'
    end

    def load_confirmation
      puts 'Do you want to load a saved game? Y/N'
    end

    def invalid_load
      puts 'Invalid load number, please choose a correct number from above.'
    end
  end
end
