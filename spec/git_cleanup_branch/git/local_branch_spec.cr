require "../../spec_helper"

describe GitCleanupBranch::Git::LocalBranch do
  describe "#to_s" do
    it "returns branch name" do
      branch = GitCleanupBranch::Git::LocalBranch.new "testing"
      branch.to_s.should eq "testing"
    end
  end
end
