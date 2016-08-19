module GitCleanupBranch::Git
  class LocalBranch < Branch
    def initialize(@branch : String)
    end

    def remove
      puts "git branch -d #{@branch}"
      Process.run "git", ["branch", "-d", @branch]
    end

    def to_s : String
      @branch
    end
  end
end
