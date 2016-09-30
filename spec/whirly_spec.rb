require_relative "../lib/whirly"
require "minitest/autorun"

describe Whirly do
  describe "usage" do
    it "outputs every frame of the spinner" do
      spinner = { "frames" => ["first", "second", "third"], "interval" => 10 }

      assert_output /first.*second.*third/m do
        Whirly.start(spinner: spinner,  non_tty: true)
        sleep 0.1
        Whirly.stop
      end
    end

    it "calls spinner proc instead of frames if proc is given" do
      spinner = { "proc" => ->(){ "frame" }, "interval" => 10 }

      assert_output /frame/ do
        Whirly.start(spinner: spinner, non_tty: true)
        sleep 0.1
        Whirly.stop
      end
    end
  end

  describe ".enabled?" do
    it "returns false if whirly was not started yet" do
      refute_predicate Whirly, :enabled?
    end

    it "returns true if whirly was started, but not yet stopped" do
      Whirly.start
      assert_predicate Whirly, :enabled?
      Whirly.stop
    end

    it "returns false if whirly was stopped" do
      Whirly.start
      Whirly.stop
      refute_predicate Whirly, :enabled?
    end
  end
end

