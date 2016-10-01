require_relative "../lib/whirly"
require "minitest/autorun"
require "irbtools/binding"
require "stringio"

describe Whirly do
  before do
    Whirly.reset
    @capture = StringIO.new
    Whirly.configure(non_tty: true, stream: @capture)
  end

  describe "Usage" do
    it "outputs every frame of the spinner" do
      spinner = { "frames" => ["first", "second", "third"], "interval" => 5 }

      Whirly.start(spinner: spinner)
      sleep 0.1
      Whirly.stop

      assert_match /first.*second.*third/m, @capture.string
    end

    it "calls spinner proc instead of frames if proc is given" do
      spinner = { "proc" => ->(){ "frame" }, "interval" => 5 }

      Whirly.start(spinner: spinner)
      sleep 0.1
      Whirly.stop

      assert_match /frame/, @capture.string
    end
  end

  describe "Configure and Reset" do
    it "can be configured before starting" do
      Whirly.configure spinner: "dots", interval: 5

      Whirly.start
      sleep 0.1
      Whirly.stop

      assert_match /⠧/, @capture.string
    end

    it "can be reset using .reset" do
      Whirly.configure spinner: "dots", interval: 5
      Whirly.reset

      Whirly.start(non_tty: true, stream: @capture)
      sleep 0.1
      Whirly.stop
      assert_match /\A[^⠧]+\z/, @capture.string
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

