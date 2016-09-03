require "ncurses"

# Mock of NCurses.
module NCurses
  class Window
    def print(message, position = nil)
      # message = "#{message.gsub("\n", "\r\n")}\033[1G" if STDOUT.tty?
      message = "#{message.gsub("\n", "\r\n")}\r\n" if STDOUT.tty?
      STDOUT.print message
    end

    def clear
    end

    def refresh
    end

    def on_input
      char = STDIN.read_byte.try(&.to_i32) || -1
      case(char)
      when 27
        on_special_input { |key, mod| yield(key, mod) }
      when 10
        yield(:return, nil)
      when 32..127
        yield(char.chr, nil)
      end
    end

    private def on_special_input
      char = STDIN.read_byte.try(&.to_i32) || -1
      if char == -1
        yield(:escape, nil)
      elsif char == 91
        char = STDIN.read_byte.try(&.to_i32) || -1
        case(char)
        when 65 then yield(:up, nil)
        when 66 then yield(:down, nil)
        end
      else
        yield(char.chr, :alt)
      end
    end
  end

  def init
    return if @@initialized
    @@initialized = true
    window = uninitialized LibNCurses::Window
    @@stdscr = Window.new window
  end

  def end_win
    @@initialized = false
  end
end
