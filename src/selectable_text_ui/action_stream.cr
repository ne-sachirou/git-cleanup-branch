module SelectableTextUI
  class ActionStream
    include Enumerable(String)

    def initialize
      @ch = Channel(UInt8).new
      spawn do
        curses do
          loop do
            break if @ch.closed?
            byte = STDIN.read_byte
            @ch.send byte if byte rescue break
          end
        end
      end
    end

    def each
      loop do
        case ord = @ch.receive
        when 3
          close
          exit
        when 4, 113
          yield "Cancel"
        when 10, 13, 32
          yield "Enter"
        when 27
          next unless @ch.receive == 91
          case @ch.receive
          when 65 then yield "Up"
          when 66 then yield "Down"
          when 67 then yield "Right"
          when 68 then yield "Left"
          end
        when 104
          yield "Left"
        when 106
          yield "Down"
        when 107
          yield "Up"
        when 108
          yield "Right"
        end
      end
    end

    def close
      @ch.close
    end

    private def curses
      if STDIN.tty?
        STDIN.noecho do
          STDIN.raw!
          yield
        end
      else
        yield
      end
    end
  end
end
