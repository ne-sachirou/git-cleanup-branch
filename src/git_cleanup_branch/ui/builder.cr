module GitCleanupBranch::UI
  class Builder
    def initialize(@ui : UI)
    end

    def text(content : String)
      @ui.add_child(TextElement.new @ui, content)
    end

    def selectable(content : String, on_enter : (SelectableElement, State) -> State)
      @ui.add_child(SelectableElement.new @ui, content, on_enter)
    end
  end
end
