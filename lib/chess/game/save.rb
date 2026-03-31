# frozen_string_literal: true

require 'json'
module Chess
  module Save
    def save_name
      print 'Enter a valid save name consisting only of letters without any special characters: '
      input = gets.chomp until valid_save_name?(input)
      input
    end

    def serialize(data = @board.fen_data)
      JSON.dump({ "#{save_name}": data })
    end

    def save
      system 'clear'
      File.new(Chess.save_path, 'a+') unless File.exist?(Chess.save_path)
      unless File.empty?(Chess.save_path)
        append_save(@board.fen_data)
        return CLI.saved
      end

      File.write(Chess.save_path, serialize, mode: 'a')
      CLI.saved
    end

    def append_save(data)
      save = Chess.deserialize
      key = save_name
      save[key] = data
      File.write(Chess.save_path, JSON.dump(save))
    end

    def valid_save_name?(name)
      !name.nil? && name.match?(/^[a-zA-Z0-9]*$/)
    end
  end
end
