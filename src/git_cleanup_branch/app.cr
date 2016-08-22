module GitCleanupBranch
  class App
    def start
      local_branches = Git::Branches.new.local_merged
      remote_branches = Git::Branches.new.remote_merged
      ui = UI::UI.new(State.new do |s|
        s[:is_canceled] = false
        s[:local] = [] of String
        s[:remote] = [] of String
      end)
      ui.build do |ui|
        ui.text "Cleanup Git merged branches interactively at both local and remote.\r\n==\r\nLocal"
        local_branches
          .map(&.to_s)
          .each { |branch| ui.selectable branch, on_enter = on_enter_branch(:local, branch) }
        ui.text "Remote"
        remote_branches
          .map(&.to_s)
          .each { |branch| ui.selectable branch, on_enter = on_enter_branch(:remote, branch) }
        ui.text "- - -"
        ui.selectable "Remove branches", on_enter = ->(element : UI::SelectableElement, state : State) { element.block.close; state }
        ui.selectable "Cancel", on_enter = ->(element : UI::SelectableElement, state : State) { state[:is_canceled] = true; element.block.close; state }
      end
      ui.draw
      begin
        ui.start.receive
      rescue Channel::ClosedError
      end
      exit if ui.state[:is_canceled]
      local_branches
        .select { |branch| ui.state[:local].as(Array(String)).includes? branch.to_s }
        .each &.remove
      remote_branches
        .select { |branch| ui.state[:remote].as(Array(String)).includes? branch.to_s }
        .each &.remove
    end

    private def on_enter_branch(location, branch)
      ->(element : UI::SelectableElement, state : State) do
        branches = state[location].as(Array(String))
        branches.includes?(branch) ? branches.delete(branch) : branches.push(branch)
        state[location] = branches
        state
      end
    end
  end
end
