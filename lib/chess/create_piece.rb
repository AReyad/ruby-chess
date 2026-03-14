module Chess
  module CreatePiece
    module_function

    def create_piece(name, color)
      name.new(color)
    end
  end
end
