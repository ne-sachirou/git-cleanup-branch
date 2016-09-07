require "../spec_helper"

describe GitCleanupBranch::AppState do
  describe "#initialize" do
    it "sets attributes default values" do
      state = GitCleanupBranch::AppState.new
      state.is_canceled.should be_false
      state.local.should eq [] of GitCleanupBranch::Git::LocalBranch
      state.remote.should eq [] of GitCleanupBranch::Git::RemoteBranch
    end
  end
end

describe GitCleanupBranch::AppUI do
end

describe GitCleanupBranch::App do
end
