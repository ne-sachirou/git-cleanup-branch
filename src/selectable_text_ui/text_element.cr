module SelectableTextUI
  class TextElement(S) < Element
    def initialize(@block : UI(S), @content : String)
    end

    def draw : String
      @content
    end
  end
end
