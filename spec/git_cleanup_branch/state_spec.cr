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
      state.should be_a GitCleanupBranch::State
    end

    it "creates a State with a block" do
      state = GitCleanupBranch::State.new do |s|
        s[:a] = 42
        s[:b] = "momonga"
      end
      state.should be_a GitCleanupBranch::State
      state[:a].as(typeof(42)).should eq 42
      state[:b].as(typeof("momonga")).should eq "momonga"
    end
  end

  describe "#[]" do
    values.each do |v, t|
      it "returns a stored #{t} value" do
        state = GitCleanupBranch::State.new { |s| s[:k] = v }
        state[:k].as(typeof(v)).should eq v
      end
    end

    it "returns nil when the key dosen't store any value" do
      state = GitCleanupBranch::State.new
      state[:k].as(Nil).should be_nil
    end
  end

  describe "#[]=" do
    values.each do |v, t|
      it "stores #{t} value" do
        state = GitCleanupBranch::State.new
        state[:k] = v
        state[:k].as(typeof(v)).should eq v
      end
    end
  end
end
