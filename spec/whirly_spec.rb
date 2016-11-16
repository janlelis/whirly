require_relative "../lib/whirly"
require "minitest/autorun"
require "paint"
# require "irbtools/binding"
require "stringio"

def short_sleep
  sleep 0.2
end

def medium_sleep
  sleep 0.6
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

    it "removes the spinner after stopping when :remove_after_stop is true" do
      Whirly.start(hide_cursor: false, remove_after_stop: true)
      short_sleep
      Whirly.stop

      assert_match /\e8\n\z/, @capture.string
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
        short_sleep
        Whirly.stop

        refute /\A.*?A.*?B.*?C.*?D.*?E.*?F.*?G.*?H/m =~ @capture.string
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

    describe "Interval" do
      it "spins more often when interval is lower" do
        capture1 = StringIO.new
        Whirly.start(stream: capture1, interval: 100)
        medium_sleep
        Whirly.stop

        capture2 = StringIO.new
        Whirly.start(stream: capture2, interval: 50)
        medium_sleep
        Whirly.stop

        assert capture1.string.size < capture2.string.size
      end
    end
  end

  describe "Colors" do
    it "will use no color when :color option is falsey" do
      Whirly.start(color: false)
      short_sleep
      Whirly.stop

      refute /\[38;5;/ =~ @capture.string
    end

    it "will use color when :color option is truthy" do
      Whirly.start(color: true)
      short_sleep
      Whirly.stop

      assert /\[38;5;/ =~ @capture.string
    end

    it "defaults :color to true when the paint gem is available" do
      Whirly.reset
      Whirly.configure
      assert Whirly.options[:color]
    end

    # it "defaults :color to true when the paint gem is not available" do
    #   remember_paint = Paint
    #   Object.send(:remove_const, :Paint)
    #   Whirly.reset
    #   Whirly.configure
    #   Object.send(:const_set, :Paint, remember_paint)
    #   refute Whirly.options[:color]
    # end

    it "changes the the color" do
      Whirly.start
      long_sleep
      Whirly.stop

      colors = @capture.string.scan(/\[38;5;(\d+)m/).flatten
      assert colors.uniq.size > 1
    end
  end

  describe "Cursor" do
    it "hides (and later shows) cursor when :hide_cursor => true option is given (default)" do
      Whirly.start(hide_cursor: true)
      short_sleep
      Whirly.stop

      assert_match /\[?25l.*\[?25h/m, @capture.string
    end

    it "does not hide cursor when :hide_cursor => false option is given" do
      Whirly.start(hide_cursor: false)
      short_sleep
      Whirly.stop

      refute /\[?25l.*\[?25h/m =~ @capture.string
    end
  end

  describe "Spinner Packs" do
    it "can be passed an alternative set of :spinner_packs" do
      assert_raises ArgumentError do
        Whirly.start(spinner_packs: [:cli], spinner: "cat") # whirly is part of :whirly, but not of :cli
        Whirly.stop
      end
    end
  end

  describe "Ansi Escape Mode" do
    it "will use save and restore ANSI sequences as default (or when 'restore') is given" do
      Whirly.start
      short_sleep
      Whirly.stop
      assert_match /\e7.*\e8/m, @capture.string
    end

    it "will use beginning of line and clear line ANSI sequences when 'line' is given" do
      Whirly.start(ansi_escape_mode: 'line')
      medium_sleep
      Whirly.stop
      assert_match /\e\[G.*\e\[1K/m, @capture.string
    end
  end

  describe "Streams and TTYs" do
    it "will not output anything on non-ttys" do
      Whirly.reset
      @capture = StringIO.new
      Whirly.start(stream: @capture)
      short_sleep
      Whirly.stop
      assert_equal "", @capture.string
    end

    it "will output something on non-ttys when :non_tty => true option is given" do
      Whirly.reset
      @capture = StringIO.new
      Whirly.start(stream: @capture, non_tty: true)
      short_sleep
      Whirly.stop
      refute_equal "", @capture.string
    end

    it "can be configured to which stream whirly's output goes" do
      iolike = StringIO.new
      Whirly.start(stream: iolike, non_tty: true)
      short_sleep
      Whirly.stop
      refute_equal "", iolike.string
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

  describe "Error Handling" do
    it "stops the spinner, when the main thread threw an exception [gh#3]" do
      begin
        Whirly.start status: "working" do
          short_sleep
          raise 'error!'
        end
      rescue
      end

      refute_predicate Whirly, :enabled?
    end
  end
end
