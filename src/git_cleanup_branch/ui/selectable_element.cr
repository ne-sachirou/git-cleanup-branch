module GitCleanupBranch::UI
  class SelectableElement < Element
    getter :block, :content
    setter :content

    def initialize(@block : UI, @content : String, @on_enter : (self, State) -> State)
      @is_selected = false
    end

    def draw(state : State) : String
      "#{@is_selected ? "*" : " "} #{@content}"
    end

    def on_enter(state : State) : State
      @is_selected = !@is_selected
      @on_enter.call(self, state)
    end
  end
end
