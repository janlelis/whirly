require_relative "../lib/whirly"
require "minitest/autorun"
# require "irbtools/binding"
require "stringio"

def short_sleep
  sleep 0.1
end

def medium_sleep
  sleep 0.4
end

def long_sleep
  sleep 1
end

describe Whirly do
  before do
    Whirly.reset
    @capture = StringIO.new
    Whirly.configure(non_tty: true, stream: @capture)
  end

  describe "General Usage" do
    it "outputs every frame of the spinner" do
      spinner = { "frames" => ["first", "second", "third"], "interval" => 5 }

      Whirly.start(spinner: spinner)
      short_sleep
      Whirly.stop

      assert_match /first.*second.*third/m, @capture.string
    end

    it "calls spinner proc instead of frames if proc is given" do
      spinner = { "proc" => ->(){ "frame" }, "interval" => 5 }

      Whirly.start(spinner: spinner)
      short_sleep
      Whirly.stop

      assert_match /frame/, @capture.string
    end
  end

  describe "Status Updates" do
    it "shows status text alongside spinner" do
      Whirly.start
      Whirly.status = "Fetching…"
      medium_sleep
      Whirly.status = "Updates…"
      medium_sleep
      Whirly.stop

      assert_match /Fetching.*Updates…/m, @capture.string
    end

    it "shows initial status" do
      Whirly.start(status: "Initial")
      short_sleep
      Whirly.stop

      assert_match /Initial/, @capture.string
    end
  end

  describe "Finishing" do
    it "shows spinner finished frame if stop is set in spinner definition" do
      spinner = { "frames" => ["first", "second", "third"], "stop" => "STOP", "interval" => 5 }

      Whirly.start(spinner: spinner)
      short_sleep
      Whirly.stop

      assert_match /STOP/, @capture.string
    end

    it "shows spinner finished frame if stop frame is passed when stopping" do
      spinner = { "frames" => ["first", "second", "third"], "interval" => 5 }

      Whirly.start(spinner: spinner)
      short_sleep
      Whirly.stop("STOP")

      assert_match /STOP/, @capture.string
    end

    it "shows spinner finished frame if stop frame is passed when starting" do
      spinner = { "frames" => ["first", "second", "third"], "interval" => 5 }

      Whirly.start(spinner: spinner, stop: "STOP")
      short_sleep
      Whirly.stop

      assert_match /STOP/, @capture.string
    end

    it "appends newline when stopping" do
      Whirly.start(hide_cursor: false)
      short_sleep
      Whirly.stop

      assert_match /\n\z/, @capture.string
    end

    it "appends no newline when stopping when :append_newline option is false" do
      Whirly.start(hide_cursor: false, append_newline: false)
      short_sleep
      Whirly.stop

      assert_match /[^\n]\z/, @capture.string
    end
  end

  describe "Spinner" do
    describe "Passing a Spinner" do
      it "can be the name of a bundled spinner (whirly-spinners)" do
        Whirly.start(spinner: "pencil")
        medium_sleep
        Whirly.stop

        assert_match /✎/, @capture.string
      end

      it "can be the name of a bundled spinner (cli-spinners)" do
        Whirly.start(spinner: "dots3")
        medium_sleep
        Whirly.stop

        assert_match /⠋/, @capture.string
      end

      it "can be an Array of frames" do
        Whirly.start(spinner: ["A", "B"])
        medium_sleep
        Whirly.stop

        assert_match /A.*B/m, @capture.string
      end

      it "can be an Enumerator of frames" do
        Whirly.start(spinner: "A".."B")
        medium_sleep
        Whirly.stop

        assert_match /A.*B/m, @capture.string
      end

      it "can be a Proc which generates frames" do
        Whirly.start(spinner: ->(){ "frame" })
        medium_sleep
        Whirly.stop

        assert_match /frame/m, @capture.string
      end
    end

    describe "Frame Mode" do
      it "can be set to random" do
        spinner = { "frames" => "A".."H", "mode" => "random", "interval" => 10 }

        Whirly.start(spinner: spinner)
        medium_sleep
        Whirly.stop

        refute /A.*B.*C.*D.*E.*F.*G.*H/m =~ @capture.string
      end

      it "can be set to reverse" do
        spinner = { "frames" => "A".."H", "mode" => "reverse", "interval" => 10 }

        Whirly.start(spinner: spinner)
        medium_sleep
        Whirly.stop

        assert_match /H.*G.*F.*E.*D.*C.*B.*A/m, @capture.string
      end

      it "can be set to swing" do
        spinner = { "frames" => "A".."H", "mode" => "swing", "interval" => 10 }

        Whirly.start(spinner: spinner)
        medium_sleep
        Whirly.stop

        assert_match /A.*B.*C.*D.*E.*F.*G.*H.*G.*F.*E.*D.*C.*B.*A/m, @capture.string
      end
    end
  end

  describe "Positioning" do
    it "will render spinner 1 line further below (useful for spinning while git cloning)" do
      Whirly.start(position: "below")
      short_sleep
      Whirly.stop

      assert_match /\n.*\e\[1A/m, @capture.string
    end
  end


  describe "Configure and Reset" do
    it "can be configured before starting" do
      Whirly.configure spinner: "dots", interval: 5

      Whirly.start
      short_sleep
      Whirly.stop

      assert_match /⠧/, @capture.string
    end

    it "can be reset using .reset" do
      Whirly.configure spinner: "dots", interval: 5
      Whirly.reset

      Whirly.start(non_tty: true, stream: @capture)
      short_sleep
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

