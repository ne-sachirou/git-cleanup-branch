module GitCleanupBranch::Git
  class RemoteBranch < Branch
    getter :remote, :branch

    def self.from_s(expression : String) : self?
      match = expression.match(%r{^([^/]+)/}).try { |m| {m[1], expression[m[0].size..-1]} }
      if match
        new match[0], match[1]
      else
        nil
      end
    end

    def initialize(@remote : String, @branch : String)
    end

    def ==(other : self)
      @remote == other.remote && @branch == other.branch
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
