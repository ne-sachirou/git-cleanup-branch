require "../spec_helper"

describe GitCleanupBranch::ActionStream do
  describe "#close" do
    it "closes the channel" do
      assert GitCleanupBranch::ActionStream.new.close == nil
    end
  end
end
