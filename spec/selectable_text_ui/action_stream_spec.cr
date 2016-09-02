require "../spec_helper"

describe SelectableTextUI::ActionStream do
  describe "#close" do
    it "closes the channel" do
      window = NCurses.init
      raise "window is nil" unless window
      begin
        SelectableTextUI::ActionStream.new(window).close.should be_nil
      ensure
        NCurses.end_win
      end
    end
  end
end
