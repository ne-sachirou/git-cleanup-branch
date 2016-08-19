module GitCleanupBranch
  class App
    def start
      local_branches = `git branch --merged`
        .each_line
        .map(&.strip)
        .reject(&.starts_with? "* ")
      remote_branches = `git branch -r --merged`
        .each_line
        .map(&.strip)
        .reject(&.match /->/)
      ui = UI::UI.new(State.new do |s|
        s[:local] = [] of String
        s[:remote] = [] of String
      end)
      ui.build do |ui|
        ui.text "Cleanup Git merged branches at both local and remote.\r\n==\r\nLocal"
        local_branches.each { |branch| ui.selectable branch, on_enter = on_enter_branch(:local, branch) }
        ui.text "Remote"
        remote_branches.each { |branch| ui.selectable branch, on_enter = on_enter_branch(:remote, branch) }
        ui.text "- - -"
        ui.selectable "Remove branches", on_enter = ->(element : UI::SelectableElement, state : State) { element.block.close; state }
        ui.selectable "Cancel", on_enter = ->(element : UI::SelectableElement, state : State) { element.block.close; state }
      end
      ui.draw
      begin
        ui.start.receive
      rescue Channel::ClosedError
      end
      (ui.state[:local].as(Array(String)))
        .each { |branch| puts "git branch -d #{branch}" }
      # .each { |branch| Process.run "git", ["branch", "-d", branch] }
      (ui.state[:remote].as(Array(String)))
        .map { |branch| m = branch.match %r{^([^/]+)/}; raise Exception.new("Invalid remote branch name: #{branch}") unless m; {m[1], branch[m.size..-1]} }
        .each { |remote, branch| puts "git push #{remote} :#{branch}" }
      # .each { |remote, branch| Process.run "git", ["push", remote, ":#{branch}"] }
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
