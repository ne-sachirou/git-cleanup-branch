module SelectableTextUI
  class ActionStream
    include Enumerable(String)

    def initialize(window : NCurses::Window)
      @ch = Channel(Symbol | Char).new
      spawn do
        loop do
          break if @ch.closed?
          window.on_input { |key, mod| @ch.send key }
        end
      end
    end

    def each
      loop do
        char = @ch.receive
        case char
        when :escape, 'q'
          yield :escape
        when :return, ' '
          yield :return
        when :up, 'k'
          yield :up
        when :down, 'j'
          yield :down
        end
      end
    rescue Channel::ClosedError
    end

    def close
      @ch.close
    end
  end
end
