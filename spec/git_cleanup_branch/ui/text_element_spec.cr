require "../../spec_helper"

describe GitCleanupBranch::UI::TextElement do
  describe "#draw" do
    it "returns given content" do
      state = GitCleanupBranch::State.new
      element = GitCleanupBranch::UI::TextElement.new(GitCleanupBranch::UI::UI.new(state), "content")
      element.draw(state).should eq "content"
    end
  end
end
