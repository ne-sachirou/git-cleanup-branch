module GitCleanupBranch::UI
  class TextElement < Element
    def initialize(@block : UI, @content : String)
    end

    def draw(state : State) : String
      @content
    end
  end
end
