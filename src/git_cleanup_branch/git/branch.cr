module GitCleanupBranch::Git
  abstract class Branch
    abstract def remove
  end
end
