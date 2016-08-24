module SelectableTextUI
  class Builder(S)
    def initialize(@ui : UI(S))
    end

    def text(content : String)
      @ui.add_child TextElement(S).new(@ui, content)
    end

    def selectable(content : String, on_enter : (SelectableElement(S), S) -> S)
      @ui.add_child SelectableElement(S).new(@ui, content, on_enter)
    end
  end
end
