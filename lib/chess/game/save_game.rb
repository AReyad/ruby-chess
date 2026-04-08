# frozen_string_literal: true

module Chess
  module SaveGame
    include Serializer

    def save_name
      CLI.save_name_msg
      loop do
        input = gets.chomp
        return input if valid_save_name?(input)

        CLI.invalid_save_name
      end
    end

    def serialize(name = save_name, data = @board.fen_string)
      serializer.dump({ "#{name}": data })
    end

    def save
      system 'clear'
      save_path = Chess.save_path
      File.new(save_path, 'a+') unless File.exist?(save_path)
      unless File.empty?(save_path)
        append_save(@board.fen_string)
        return CLI.saved
      end

      File.write(save_path, serialize, mode: 'a')
      CLI.saved
    end

    def append_save(data)
      save = deserialize
      key = save_name
      save[key] = data
      File.write(Chess.save_path, serializer.pretty_generate(save))
    end

    def valid_save_name?(name)
      !name.nil? && name.match?(/^[a-zA-Z0-9_-]*$/) && name != ''
    end
  end
end
