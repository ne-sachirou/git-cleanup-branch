module GitCleanupBranch
  class ActionStream
    include Enumerable(String)

    def initialize
      @ch = Channel(Int32).new
      spawn do
        loop do
          begin
            @ch.send `read -rsn1 key 2> /dev/null && echo $key`[0].ord
          rescue Channel::ClosedError
            break
          end
        end
      end
    end

    def each
      loop do
        case ord = @ch.receive
        when 4, 113
          yield "Cancel"
        when 10
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
  end
end
