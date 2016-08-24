module SelectableTextUI
  class UI(S)
    @focusing : SelectableElement(S)?

    getter :state

    def initialize(@state : S)
      @children = [] of Element
      @content = ""
    end

    def start
      @ch = ch = Channel(Symbol).new
      @actions = actions = ActionStream.new
      spawn do
        loop do
          begin
            actions.each { |action| react action }
          rescue Channel::ClosedError
            break
          end
        end
      end
      ch
    end

    def close
      @actions.try &.close
      @ch.try &.close
    end

    def build(&builder : Builder(S) ->)
      builder.call Builder(S).new self
    end

    def add_child(element : Element)
      @children.push element
      @focusing = element if @focusing.nil? && element.is_a?(SelectableElement(S))
    end

    def draw
      next_content = @children.map { |element|
        case element
        when TextElement(S)
          element.draw
        when SelectableElement(S)
          "#{element == @focusing ? ">" : " "} #{element.draw}"
        else
          raise Exception.new "NotImplemented"
        end
      }.join("\r\n")
      @content.each_line { print "\033[1A\033[1G\033[0K" }
      puts "#{next_content}\033[1G"
      @content = next_content
    end

    private def react(action)
      case action
      when "Cancel"
        close
      when "Enter"
        @state = @focusing.as(SelectableElement(S)).on_enter(@state) if @focusing
        draw
      when "Down"
        return unless @focusing
        next_option = @children.skip_while { |element| element != @focusing }.skip(1).find(&.is_a? SelectableElement(S)).as(SelectableElement(S)?)
        @focusing = next_option if next_option
        draw
      when "Up"
        return unless @focusing
        next_option = @children.take_while { |element| element != @focusing }.to_a.reverse.find(&.is_a? SelectableElement(S)).as(SelectableElement(S)?)
        @focusing = next_option if next_option
        draw
      end
    end
  end
end
