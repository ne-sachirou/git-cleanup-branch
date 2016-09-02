require "../spec_helper"

describe SelectableTextUI::TextElement do
  describe "#draw" do
    it "returns given content" do
      element = SelectableTextUI::TextElement.new(SelectableTextUI::UI.new(nil), "content")
      element.draw.should eq "content"
    end
  end
end
