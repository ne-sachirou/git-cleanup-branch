require "../spec_helper"

describe SelectableTextUI::ActionStream do
  describe "#close" do
    it "closes the channel" do
      SelectableTextUI::ActionStream.new.close.should be_nil
    end
  end
end
