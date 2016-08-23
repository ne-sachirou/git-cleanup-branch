require "../spec_helper"

describe GitCleanupBranch::ActionStream do
  describe "#close" do
    it "closes the channel" do
      GitCleanupBranch::ActionStream.new.close.should be_nil
    end
  end
end
