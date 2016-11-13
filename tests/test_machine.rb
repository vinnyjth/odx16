require "minitest/autorun"
require_relative "../machine"

describe Machine do
  before do
    @m = Machine.new
  end

  describe "When created." do
    it "Sets up multiple memory registers." do
      # TODO: Test.
    end
  end

  describe "when running a block of code" do
    it "it heats up" do
      code = "plus 10 mea1"
      @m.compile(code)
      @m.heat_history.last.must_equal(20)
    end
    it "heats up more for certain instructions" do
      code = "
      plus 10 mea1
      plus 10 mea1
      "
      @m.compile(code)
      @m.heat_history.last.must_equal(40)
    end

    it "doesn't allow non-whitelisted instructions'" do
      code = "
      plus 10 mea1
      class
      "
      proc { @m.compile(code) }.must_raise StandardError
    end
  end
end
