require "../../spec_helper"

describe GitCleanupBranch::Git::RemoteBranch do
  describe ".from_s" do
    it "returns nil when the expression is invalid" do
      GitCleanupBranch::Git::RemoteBranch.from_s("origin master").should be_nil
    end

    it "creates a RemoteBranch when the expression is valid" do
      GitCleanupBranch::Git::RemoteBranch.from_s("origin/master").should eq GitCleanupBranch::Git::RemoteBranch.new("origin", "master")
    end
  end

  describe "#==" do
    it "is true when both remotes & branches are same" do
      GitCleanupBranch::Git::RemoteBranch.new("origin", "master").should eq GitCleanupBranch::Git::RemoteBranch.new("origin", "master")
    end

    it "is false when remotes are not same" do
      GitCleanupBranch::Git::RemoteBranch.new("origin", "master").should_not eq GitCleanupBranch::Git::RemoteBranch.new("another", "master")
    end

    it "is false when branches are not same" do
      GitCleanupBranch::Git::RemoteBranch.new("origin", "master").should_not eq GitCleanupBranch::Git::RemoteBranch.new("origin", "another")
    end
  end

  describe "#to_s" do
    it "returns remote & branch name" do
      branch = GitCleanupBranch::Git::RemoteBranch.new "test", "testing"
      branch.to_s.should eq "test/testing"
    end
  end
end
