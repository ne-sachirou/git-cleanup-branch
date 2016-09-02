module GitCleanupBranch
  class AppState
    getter :is_canceled, :local, :remote
    setter :is_canceled, :local, :remote

    def initialize
      @is_canceled = false
      @local = [] of Git::LocalBranch
      @remote = [] of Git::RemoteBranch
    end
  end

  class App
    def start
      local_branches = Git::Branches.new.local_merged
      remote_branches = Git::Branches.new.remote_merged
      ui = SelectableTextUI::UI.new(AppState.new)
      ui.build do |ui|
        ui.text "Cleanup Git merged branches interactively at both local and remote.\n==\nLocal"
        local_branches.each { |branch| ui.selectable branch.to_s, on_enter = on_enter_branch(branch) }
        ui.text "Remote"
        remote_branches.each { |branch| ui.selectable branch.to_s, on_enter = on_enter_branch(branch) }
        ui.text "- - -"
        ui.selectable "Remove branches", on_enter = ->(element : SelectableTextUI::SelectableElement(AppState), state : AppState) { element.block.close; state }
        ui.selectable "Cancel", on_enter = ->(element : SelectableTextUI::SelectableElement(AppState), state : AppState) { state.is_canceled = true; element.block.close; state }
        ui.on_cancel { |ui, state| state.is_canceled = true; ui.close; state }
      end
      begin
        ui.start.receive
      rescue Channel::ClosedError
      ensure
        ui.close
      end
      exit if ui.state.is_canceled
      ui.state.local.each &.remove
      ui.state.remote.each &.remove
    end

    private def on_enter_branch(branch : Git::Branch)
      ->(element : SelectableTextUI::SelectableElement(AppState), state : AppState) do
        case branch
        when Git::LocalBranch
          state.local.includes?(branch) ? state.local.delete(branch) : state.local.push(branch.as(Git::LocalBranch))
        when Git::RemoteBranch
          state.remote.includes?(branch) ? state.remote.delete(branch) : state.remote.push(branch.as(Git::RemoteBranch))
        else
          raise Exception.new "NotImplemented"
        end
        state
      end
    end
  end
end
