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
      @window = window = NCurses.init
      raise "Can't initialize ncurses." unless window
      @actions = actions = ActionStream.new window
      window.refresh
      draw
      spawn do
        actions.each do |action|
          react action
          draw
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
        on_cancel = @on_cancel
        @state = on_cancel.call self, @state if on_cancel
      when :return
        @state = @focusing.as(SelectableElement(S)).on_enter(@state) if @focusing
      when :down
        return unless @focusing
        next_option = @children.skip_while { |element| element != @focusing }.skip(1).find(&.is_a? SelectableElement(S)).as(SelectableElement(S)?)
        @focusing = next_option if next_option
      when :up
        return unless @focusing
        next_option = @children.take_while { |element| element != @focusing }.to_a.reverse.find(&.is_a? SelectableElement(S)).as(SelectableElement(S)?)
        @focusing = next_option if next_option
      end
    end

    private def draw
      window = @window
      raise "ncurses inn't initialized yet." unless window
      next_content = @children.map { |element|
        case element
        when TextElement(S)
          element.draw
        when SelectableElement(S)
          "#{element == @focusing ? ">" : " "}#{element.draw}"
        else
          raise Exception.new "NotImplemented"
        end
      }.join("\n")
      window.clear
      next_content.each_line { |line| window.print line }
      @content = next_content
    end
  end
end
