module Chess
  module CreatePiece
    module_function

    def piece(name, color)
      name.new(color)
    end
  end
end
