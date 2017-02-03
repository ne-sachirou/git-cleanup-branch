module SelectableTextUI
  class ActionStream
    include Enumerable(String)

    def initialize(window : Termbox::Window)
      window.set_input_mode Termbox::INPUT_ESC | Termbox::INPUT_MOUSE
      @ch = Channel(TermboxBindings::Event).new
      spawn do
        loop do
          break if @ch.closed?
          @ch.send window.poll
        end
      end
    end

    def each(&block : Symbol ->)
      loop do
        event = @ch.receive
        next unless event.type == Termbox::EVENT_KEY
        if [Termbox::KEY_CTRL_C, Termbox::KEY_ESC].includes?(event.key) || event.ch == 'q'.ord
          yield :escape
        elsif [Termbox::KEY_ENTER, Termbox::KEY_SPACE].includes? event.key
          yield :return
        elsif event.key == Termbox::KEY_ARROW_UP || event.ch == 'k'.ord
          yield :up
        elsif event.key == Termbox::KEY_ARROW_DOWN || event.ch == 'j'.ord
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
