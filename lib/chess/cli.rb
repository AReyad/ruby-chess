module Chess
  module CLI
    module_function

    def turn(player)
      print "=> #{player.name}'s turn select a piece to move or type (exit) to quit: "
    end

    def invalid_selection(player, piece)
      return empty_tile if piece.nil?

      return no_safe_moves(piece) if player.color == piece.color

      different_color_piece(piece)
    end

    def invalid_incheck_selection(player, piece)
      return empty_tile if piece.nil?

      return cant_defend_king(piece) if player.color == piece.color

      different_color_piece(piece)
    end

    def empty_tile
      puts "=> Invalid selection, you can't select an empty tile!"
      print '=> '
    end

    def cant_defend_king(piece)
      puts "#{piece} can't defend king"
      print '=> '
    end

    def post_selection(moves)
      print "=> Pick a move from the following: (#{MoveConverter.convert_moves(moves)}) or type back to select another piece: "
    end

    def no_safe_moves(piece)
      puts "=> #{piece} can't make any safe moves, select another piece."
      print '=> '
    end

    def different_color_piece(piece)
      puts "=> #{piece} is of a different color, select a piece with the same color as yours."
      print '=> '
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
      print '=> '
    end

    def save_confirmation
      system 'clear'
      puts '=> Do you want to save the game? Y\n'
      print '=> '
    end

    def exited
      puts '=> Exited without saving!'
    end

    def saved
      puts 'Game saved successfully.'
    end

    def load_confirmation
      puts 'Do you want to load a saved game? Y/N'
      print '=> '
    end

    def invalid_option(max, min = 1)
      puts "Invalid option number, please choose a correct number between #{min} and #{max}."
      print '=> '
    end

    def load_option_msg
      '=> Type the number of the save you want to load: '
    end

    def promotion_option_msg
      '=> Type the number of promotion you want to promote your pawn into: '
    end

    def save_name_msg
      puts 'Enter a valid save name consisting only of letters without any special characters.'
      puts 'Example of valid save names: (save_name, save-name, savename)'
      print '=> '
    end

    def invalid_save_name
      puts 'Invalid save name, please input a valid save name!'
      print '=> '
    end
  end
end
