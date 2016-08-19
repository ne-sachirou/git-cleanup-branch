require "../../spec_helper"

describe GitCleanupBranch::UI::SelectableElement do
  describe "#draw" do
    it "returns given content without a mark when it's not is_selected" do
      state = GitCleanupBranch::State.new
      element = GitCleanupBranch::UI::SelectableElement.new(
        GitCleanupBranch::UI::UI.new(state),
        "option",
        on_enter = ->(e : GitCleanupBranch::UI::SelectableElement, s : GitCleanupBranch::State) { s }
      )
      actual = element.draw state
      assert actual == "  option"
    end

    it "returns given content with a mark when it's is_selected" do
      state = GitCleanupBranch::State.new
      element = GitCleanupBranch::UI::SelectableElement.new(
        GitCleanupBranch::UI::UI.new(state),
        "option",
        on_enter = ->(e : GitCleanupBranch::UI::SelectableElement, s : GitCleanupBranch::State) { s }
      )
      element.on_enter state
      actual = element.draw state
      assert actual == "* option"
    end
  end

  describe "#on_enter" do
    it "toggles is_selected" do
      state = GitCleanupBranch::State.new
      element = GitCleanupBranch::UI::SelectableElement.new(
        GitCleanupBranch::UI::UI.new(state),
        "option",
        on_enter = ->(e : GitCleanupBranch::UI::SelectableElement, s : GitCleanupBranch::State) { s }
      )
      assert !element.draw(state).starts_with?("*")
      element.on_enter state
      assert !!element.draw(state).starts_with?("*")
      element.on_enter state
      assert !element.draw(state).starts_with?("*")
    end

    it "calls given on_enter with self & given state" do
      on_enter_called? = false
      on_enter_arg_element = nil
      on_enter_arg_state = nil
      state = GitCleanupBranch::State.new
      element = GitCleanupBranch::UI::SelectableElement.new(
        GitCleanupBranch::UI::UI.new(state),
        "option",
        on_enter = ->(e : GitCleanupBranch::UI::SelectableElement, s : GitCleanupBranch::State) do
          on_enter_called? = true
          on_enter_arg_element = e
          on_enter_arg_state = s
        end
      )
      element.on_enter state
      assert on_enter_called?
      actual = on_enter_arg_element.hash
      expected = element.hash
      assert actual == expected
      actual = on_enter_arg_state.hash
      expected = state.hash
      assert actual == expected
    end
  end
end
