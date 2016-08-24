require "../../spec_helper"

describe GitCleanupBranch::UI::TextElement do
  describe "#draw" do
    it "returns given content" do
      element = GitCleanupBranch::UI::TextElement.new(GitCleanupBranch::UI::UI.new(nil), "content")
      element.draw.should eq "content"
    end
  end
end
