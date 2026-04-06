require 'json'

module Chess
  module Serializer
    def serializer
      JSON
    end

    def deserialize
      serializer.parse(File.read(Chess.save_path))
    end
  end
end
