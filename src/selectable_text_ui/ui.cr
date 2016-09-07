module SelectableTextUI
  class UI(S)
    @focusing : SelectableElement(S)?
    @on_cancel : ((UI(S), S) -> S)?

    getter :state
    setter :on_cancel

    def initialize(@state : S)
      @children = [] of Element
      @content = ""
    end

    def start
      @ch = ch = Channel(Symbol).new
      window = NCurses.init
      raise "Can't initialize ncurses." unless window
      @actions = actions = ActionStream.new window
      window.refresh
      draw window
      spawn do
        actions.each do |action|
          react action
          draw window
        end
      end
      ch
    end

    def close
      @actions.try &.close
      @ch.try &.close
      NCurses.end_win
    end

    def build(&builder : Builder(S) ->)
      builder.call Builder(S).new self
    end

    def add_child(element : Element)
      @children.push element
      @focusing = element if @focusing.nil? && element.is_a?(SelectableElement(S))
    end

    private def react(action)
      case action
      when :escape
        @on_cancel.try { |on_cancel| @state = on_cancel.call self, @state }
      when :return
        @focusing.try { |focusing| @state = focusing.on_enter @state }
      when :down
        return unless @focusing
        @children
          .skip_while { |element| element != @focusing }
          .skip(1)
          .find(&.is_a? SelectableElement(S)).as(SelectableElement(S)?)
          .try { |next_option| @focusing = next_option }
      when :up
        return unless @focusing
        @children
          .take_while { |element| element != @focusing }
          .to_a
          .reverse
          .find(&.is_a? SelectableElement(S)).as(SelectableElement(S)?)
          .try { |next_option| @focusing = next_option }
      end
    end

    private def draw(window : Nil)
      raise "ncurses isn't initialized yet."
    end
    private def draw(window : NCurses::Window)
      next_content = @children.map { |element|
        case element
        when TextElement(S)
          element.draw
        when SelectableElement(S)
          "#{element == @focusing ? ">" : " "}#{element.draw}"
        end
      }.join("\n")
      window.clear
      next_content.each_line { |line| window.print line }
      @content = next_content
    end
  end
end
