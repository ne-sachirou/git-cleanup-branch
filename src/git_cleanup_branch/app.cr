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

  class AppUI
    include SelectableTextUI

    def initialize(local_branches : Array(Git::LocalBranch), remote_branches : Array(Git::RemoteBranch))
      @ui = UI(AppState).new AppState.new
      @ui.build do |ui|
        ui.static_box do |ui|
          ui.text "Cleanup Git merged branches interactively at both local and remote.\n=="
        end
        ui.scrollable_box do |ui|
          ui.text "Local"
          local_branches.each { |branch| ui.selectable branch.to_s, on_enter = on_enter_branch(branch) }
          ui.text "Remote"
          remote_branches.each { |branch| ui.selectable branch.to_s, on_enter = on_enter_branch(branch) }
        end
        ui.static_box do |ui|
          ui.selectable "- - -\nRemove branches",
            on_enter = ->(e : SelectableElement(AppState), s : AppState) { e.block.close; s }
          ui.selectable "Cancel",
            on_enter = ->(e : SelectableElement(AppState), s : AppState) { cancel e.block, s }
        end
        ui.on_cancel &->cancel(UI(AppState), AppState)
      end
    end

    def start : AppState
      begin
        @ui.start.receive
      rescue Channel::ClosedError
      ensure
        @ui.close
      end
      @ui.state
    end

    private def on_enter_branch(branch : Git::Branch)
      ->(e : SelectableElement(AppState), s : AppState) do
        case branch
        when Git::LocalBranch
          s.local.includes?(branch) ? s.local.delete(branch) : s.local.push(branch.as(Git::LocalBranch))
        when Git::RemoteBranch
          s.remote.includes?(branch) ? s.remote.delete(branch) : s.remote.push(branch.as(Git::RemoteBranch))
        end
        s
      end
    end

    private def cancel(ui : UI(AppState), state : AppState) : AppState
      state.is_canceled = true
      ui.close
      state
    end
  end

  class App
    def start
      Git::Branches.refresh
      state = AppUI.new(
        Git::Branches.new.local_merged,
        Git::Branches.new.remote_merged
      ).start
      exit if state.is_canceled
      (state.local + state.remote).each &.remove
      Git::Branches.refresh state.remote.map(&.remote)
    end
  end
end
