module SelectableTextUI
  class SelectableElement(S) < Element
    getter :block, :content
    setter :content

    def initialize(@block : UI(S), @content : String, @on_enter : (SelectableElement(S), S) -> S)
      @is_selected = false
    end

    def draw : String
      "#{@is_selected ? "*" : " "} #{@content}"
    end

    def on_enter(state : S) : S
      @is_selected = !@is_selected
      @on_enter.call self, state
      state
    end
  end
end
