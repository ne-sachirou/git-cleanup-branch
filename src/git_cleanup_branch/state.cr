require "big_rational"

module GitCleanupBranch
  alias StateValue = State | String | BigRational | BigFloat | Float32 | Float64 | BigInt | Int16 | Int32 | Int64 | Int8 | UInt16 | UInt32 | UInt64 | UInt8 | Nil | Array(State) | Array(String) | Array(BigRational) | Array(BigFloat) | Array(Float32) | Array(Float64) | Array(BigInt) | Array(Int16) | Array(Int32) | Array(Int64) | Array(Int8) | Array(UInt16) | Array(UInt32) | Array(UInt64) | Array(UInt8) | Array(Nil)

  class State
    def initialize(&builder : State ->)
      @state = {} of Symbol => StateValue
      builder.call self
    end

    def [](key : Symbol) : StateValue
      @state.fetch(key, nil)
    end

    def []=(key : Symbol, val : StateValue)
      @state[key] = val
    end
  end
end
