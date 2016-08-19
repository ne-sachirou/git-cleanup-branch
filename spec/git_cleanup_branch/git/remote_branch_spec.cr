require "../../spec_helper"

describe GitCleanupBranch::Git::RemoteBranch do
  describe "#to_s" do
    it "returns remote & branch name" do
      branch = GitCleanupBranch::Git::RemoteBranch.new "test", "testing"
      assert branch.to_s == "test/testing"
    end
  end
end
