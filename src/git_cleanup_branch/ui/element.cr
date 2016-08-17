module GitCleanupBranch::UI
  abstract class Element
    abstract def draw(state : State) : String
  end
end
