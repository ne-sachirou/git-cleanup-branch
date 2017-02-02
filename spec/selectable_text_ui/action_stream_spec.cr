require "../spec_helper"

describe SelectableTextUI::ActionStream do
  describe "#close" do
    it "closes the channel" do
      window = Termbox::Window.new
      raise "window is nil" unless window
      begin
        SelectableTextUI::ActionStream.new(window).close.should be_nil
      ensure
        window.shutdown
      end
    end
  end
end
