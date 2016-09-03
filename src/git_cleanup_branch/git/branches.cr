module GitCleanupBranch::Git
  class Branches
    def local_merged : Array(LocalBranch)
      `git branch --merged`
        .each_line
        .reject(&.starts_with? "* ")
        .map(&.strip)
        .map { |branch| LocalBranch.new branch }
        .to_a
    end

    def remote_merged : Array(RemoteBranch)
      `git branch -r --merged`
        .each_line
        .reject(&.match /->/)
        .map(&.strip)
        .map { |branch| branch.match(%r{^([^/]+)/}).try { |m| {m[1], branch[m[0].size..-1]} } }
        .to_a
        .compact
        .map { |remote, branch| RemoteBranch.new remote, branch }
        .to_a
    end
  end
end
