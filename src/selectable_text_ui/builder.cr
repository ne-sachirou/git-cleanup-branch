module SelectableTextUI
  class Builder(S)
    def initialize(@ui : UI(S))
    end

    def static_box(&builder : Builder(S) ->)
      builder.call self.class.new UI.new(@ui.state)
    end

    def scrollable_box(&builder : Builder(S) ->)
      builder.call self.class.new UI.new(@ui.state)
    end

    def text(content : String)
      @ui.add_child TextElement(S).new(@ui, content)
    end

    def selectable(content : String, on_enter : (SelectableElement(S), S) -> S)
      @ui.add_child SelectableElement(S).new(@ui, content, on_enter)
    end

    def on_cancel(&callback : (UI(S), S) -> S)
      @ui.on_cancel = callback
    end
  end
end
