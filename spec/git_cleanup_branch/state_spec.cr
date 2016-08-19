require "../spec_helper"

describe GitCleanupBranch::State do
  values = [
    {"momonga", typeof("momonga")},
    {42, typeof(42)},
    {nil, typeof(nil)},
    {["momonga"], typeof(["momonga"])},
  ]

  describe "#initialize" do
    it "creates an empty State without block" do
      state = GitCleanupBranch::State.new
      assert state.is_a? GitCleanupBranch::State
    end

    it "creates a State with a block" do
      state = GitCleanupBranch::State.new do |s|
        s[:a] = 42
        s[:b] = "momonga"
      end
      assert state.is_a? GitCleanupBranch::State
      assert state[:a].as(typeof(42)) == 42
      assert state[:b].as(typeof("momonga")) == "momonga"
    end
  end

  describe "#[]" do
    values.each do |v, t|
      it "returns a stored #{t} value" do
        state = GitCleanupBranch::State.new { |s| s[:k] = v }
        assert state[:k].as(typeof(v)) == v
      end
    end

    it "returns nil when the key dosen't store any value" do
      state = GitCleanupBranch::State.new { }
      assert state[:k].as(Nil) == nil
    end
  end

  describe "#[]=" do
    values.each do |v, t|
      it "stores #{t} value" do
        state = GitCleanupBranch::State.new { }
        state[:k] = v
        assert state[:k].as(typeof(v)) == v
      end
    end
  end
end
