require "../../spec_helper"

describe GitCleanupBranch::UI::SelectableElement do
  describe "#draw" do
    it "returns given content without a mark when it's not is_selected" do
      element = GitCleanupBranch::UI::SelectableElement.new(
        GitCleanupBranch::UI::UI.new(42),
        "option",
        on_enter = ->(e : GitCleanupBranch::UI::SelectableElement(Int32), s : Int32) { s }
      )
      element.draw.should eq "  option"
    end

    it "returns given content with a mark when it's is_selected" do
      element = GitCleanupBranch::UI::SelectableElement.new(
        GitCleanupBranch::UI::UI.new(42),
        "option",
        on_enter = ->(e : GitCleanupBranch::UI::SelectableElement(Int32), s : Int32) { s }
      )
      element.on_enter 42
      element.draw.should eq "* option"
    end
  end

  describe "#on_enter" do
    it "toggles is_selected" do
      element = GitCleanupBranch::UI::SelectableElement.new(
        GitCleanupBranch::UI::UI.new(42),
        "option",
        on_enter = ->(e : GitCleanupBranch::UI::SelectableElement(Int32), s : Int32) { s }
      )
      element.draw.should_not match /^\*/
      element.on_enter 42
      element.draw.should match /^\*/
      element.on_enter 42
      element.draw.should_not match /^\*/
    end

    it "calls given on_enter with self & given state" do
      on_enter_called? = false
      on_enter_arg_element = nil
      on_enter_arg_state = nil
      state = {} of Symbol => String
      element = GitCleanupBranch::UI::SelectableElement.new(
        GitCleanupBranch::UI::UI.new(state),
        "option",
        on_enter = ->(e : GitCleanupBranch::UI::SelectableElement(Hash(Symbol, String)), s : Hash(Symbol, String)) do
          on_enter_called? = true
          on_enter_arg_element = e
          on_enter_arg_state = s
        end
      )
      element.on_enter state
      on_enter_called?.should be_true
      on_enter_arg_element.hash.should eq element.hash
      on_enter_arg_state.hash.should eq state.hash
    end
  end
end
