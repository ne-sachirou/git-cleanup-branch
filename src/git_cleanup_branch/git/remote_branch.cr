module GitCleanupBranch::Git
  class RemoteBranch < Branch
    def initialize(@remote : String, @branch : String)
    end

    def remove
      puts "git push #{@remote} :#{@branch}"
      Process.run "git", ["push", @remote, ":#{@branch}"]
    end

    def to_s : String
      "#{@remote}/#{@branch}"
    end
  end
end
