require "../../spec_helper"

describe GitCleanupBranch::Git::RemoteBranch do
  describe "#to_s" do
    it "returns remote & branch name" do
      branch = GitCleanupBranch::Git::RemoteBranch.new "test", "testing"
      branch.to_s.should eq "test/testing"
    end
  end
end
