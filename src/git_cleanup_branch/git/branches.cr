module GitCleanupBranch::Git
  class Branches
    def self.refresh
      `git fetch -p --all` rescue nil
    end

    def self.refresh(remotes : Array(String))
      remotes.each { |remote| Process.run "git", ["remote", "prune", remote] }
    end

    def local_merged : Array(LocalBranch)
      `git branch --merged`
        .each_line
        .reject(&.starts_with? "* ")
        .map(&.strip)
        .map { |branch| LocalBranch.new branch }
        .to_a
    end

    def remote_merged : Array(RemoteBranch)
      upstream = RemoteBranch.from_s `git rev-parse --abbrev-ref HEAD@{upstream}`.strip
      `git branch -r --merged`
        .each_line
        .reject(&.match /->/)
        .map { |branch| RemoteBranch.from_s branch.strip }
        .reject { |branch| branch == upstream }
        .to_a
        .compact
    end
  end
end
