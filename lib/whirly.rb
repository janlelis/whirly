require_relative "whirly/version"
require_relative "whirly/spinners"

begin
  require "paint"
rescue LoadError
end

# TODO configure extra-line below
# TODO clear previous frame

module Whirly
  CLI_COMMANDS = {
    hide_cursor: "\x1b[?25l",
    show_cursor: "\x1b[?25h",
  }

  class << self
    attr_accessor :status
  end

  def self.enabled?
    @enabled
  end

  def self.paused?
    @paused
  end

  def self.start(stream: $stdout,
                 interval: nil,
                 spinner: "whirly",
                 use_color: defined?(Paint),
                 color_change_rate: 30,
                 status: nil,
                 hide_cursor: true,
                 non_tty: false)
    # only actviate if we are on a real terminal (or forced)
    return false unless stream.tty? || non_tty

    # ensure cursor is visible after exit
    at_exit{ @stream.print CLI_COMMANDS[:show_cursor] } if !defined?(@enabled) && hide_cursor

    # only activate once
    return false if @enabled

    # save options and preprocess
    @enabled  = true
    @paused   = false
    @stream   = stream
    @status   = status
    if spinner.is_a? Hash
      @spinner = spinner
    else
      @spinner  = SPINNERS[spinner.to_s]
    end
    raise(ArgumentError, "Whirly: Invalid spinner given") if !@spinner || (!@spinner["frames"] && !@spinner["proc"])
    @hide_cursor = hide_cursor
    @interval = (interval || @spinner["interval"] || 100) * 0.001
    @frames   = @spinner["frames"] && @spinner["frames"].cycle
    @proc     = @spinner["proc"]

    # init color
    if use_color
      if defined?(Paint)
        @color = "%.6x" % rand(16777216)
        @color_directions = (0..2).map{ |e| rand(3) - 1 }
        @color_change_rate = color_change_rate
      else
        warn "Whirly warning: Using colors requires the paint gem"
      end
    end

    # hide cursor
    @stream.print CLI_COMMANDS[:hide_cursor] if @hide_cursor

    # start spinner loop
    @thread = Thread.new do
      while true # it's just a spinner, no exact timing here
        next_color if @color
        render
        sleep(@interval)
      end
    end

    # idiomatic block syntax
    if block_given?
      yield
      Whirly.stop
    end

    true
  end

  def self.stop(delete = false)
    return false unless @enabled
    @thread.terminate
    @enabled = false
    @stream.print CLI_COMMANDS[:show_cursor] if @hide_cursor
    print "TODO" if delete

    true
  end

  def self.pause
    # unrender
    @paused = true
    @stream.print CLI_COMMANDS[:show_cursor] if @hide_cursor
    if block_given?
      yield
      continue
    end
  end

  def self.continue
    @stream.print CLI_COMMANDS[:hide_cursor] if @hide_cursor
    @paused = false
  end

  def self.unrender
    return unless @current_frame
    current_frame_size = @current_frame.size
    @stream.print "\n\e[s#{' ' * current_frame_size}\e[u\e[1A"
  end

  def self.render
    return if @paused
    unrender
    @current_frame = @proc ? @proc.call : @frames.next
    @current_frame = Paint[@current_frame, @color] if @color
    @current_frame += "  #{@status}" if @status
    # @stream.print "\e[s#{@current_frame}\e[u"
    @stream.print "\n\e[s#{@current_frame}\e[u\e[1A"
  end

  def self.next_color
    @color = @color.scan(/../).map.with_index{ |c, i|
      color_change = rand(@color_change_rate) * @color_directions[i]
      nc = c.to_i(16) + color_change
      if nc <= 0
        nc = 0
        @color_directions[i] = rand(3) - 1
      elsif nc >= 255
        nc = 255
        @color_directions[i] = rand(3) - 1
      end
      "%.2x" % nc
    }.join
  end
end
