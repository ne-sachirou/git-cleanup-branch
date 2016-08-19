require "../../spec_helper"

describe GitCleanupBranch::UI::TextElement do
  describe "#draw" do
    it "returns given content" do
      state = GitCleanupBranch::State.new
      element = GitCleanupBranch::UI::TextElement.new(GitCleanupBranch::UI::UI.new(state), "content")
      actual = element.draw state
      assert actual == "content"
    end
  end
end
