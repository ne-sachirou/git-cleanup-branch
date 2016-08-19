require "../../spec_helper"

describe GitCleanupBranch::Git::LocalBranch do
  describe "#to_s" do
    it "returns branch name" do
      branch = GitCleanupBranch::Git::LocalBranch.new "testing"
      assert branch.to_s == "testing"
    end
  end
end
