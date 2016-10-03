require_relative "whirly/version"
require_relative "whirly/spinners"

begin
  require "paint"
rescue LoadError
end

module Whirly
  CLI_COMMANDS = {
    hide_cursor: "\x1b[?25l",
    show_cursor: "\x1b[?25h",
  }.freeze

  DEFAULT_OPTIONS = {
    spinner: "whirly",
    stream: $stdout,
    status: nil,
    hide_cursor: true,
    non_tty: false,
    use_color: !!defined?(Paint),
    color_change_rate: 30,
    append_newline: true,
    position: "normal",
  }.freeze

  SOFT_DEFAULT_OPTIONS = {
    mode: "linear",
    interval: 100,
  }.freeze

  class << self
    attr_accessor :status
    attr_reader :options

    def enabled?
      !!(defined?(@enabled) && @enabled)
    end

    def configured?
      !!(defined?(@configured) && @configured)
    end
  end

  # set spinner directly or lookup
  def self.configure_spinner(spinner_option)
    if spinner_option.is_a? Hash
      spinner = spinner_option.dup
    else
      spinner = SPINNERS[spinner_option].dup
    end

    # validate spinner
    if !spinner || (!spinner["frames"] && !spinner["proc"])
      raise(ArgumentError, "Whirly: Invalid spinner given")
    end

    spinner
  end

  # frames can be generated from enumerables or procs
  def self.configure_frames(spinner)
    if spinner["frames"]
      case spinner["mode"]
      when "swing"
        frames = (spinner["frames"].to_a + spinner["frames"].to_a[1..-2].reverse).cycle
      when "random"
        frame_pool = spinner["frames"].to_a
        frames = ->(){ frame_pool.sample }
      when "reverse"
        frames = spinner["frames"].to_a.reverse.cycle
      else
        frames = spinner["frames"].cycle
      end
    else
      frames = spinner["proc"].dup
    end

    if frames.is_a? Proc
      class << frames
        alias next call
      end
    end

    frames
  end

  # save options and preprocess, set defaults if value is still unknown
  def self.configure(**options)
    if !defined?(@configured) || !@configured || !defined?(@options) || !@options
      @options = DEFAULT_OPTIONS.dup
      @configured = true
    end

    @options.merge!(options)

    spinner   = configure_spinner(@options[:spinner])
    spinner_overwrites = {}
    spinner_overwrites["mode"] = @options[:mode] if @options.key?(:mode)
    @frames   = configure_frames(spinner.merge(spinner_overwrites))

    @interval = (@options[:interval] || spinner["interval"] || SOFT_DEFAULT_OPTIONS[:interval]) * 0.001
    @stop     = @options[:stop] || spinner["stop"]
    @status   = @options[:status]
  end

  def self.start(**options)
    # optionally overwrite configuration on start
    configure(**options)

    # ensure cursor is visible after exit the program (only register for the very first time)
    if (!defined?(@at_exit_handler_registered) || !@at_exit_handler_registered) && @options[:hide_cursor]
      @at_exit_handler_registered = true
      stream = @options[:stream]
      at_exit{ stream.print CLI_COMMANDS[:show_cursor] }
    end

    # only enable once
    return false if defined?(@enabled) && @enabled

    # set status to enabled
    @enabled = true

    # only do something if we are on a real terminal (or forced)
    return false unless @options[:stream].tty? || @options[:non_tty]

    # init color
    initialize_color if @options[:use_color]

    # hide cursor
    @options[:stream].print CLI_COMMANDS[:hide_cursor] if @options[:hide_cursor]

    # start spinner loop
    @thread = Thread.new do
      @current_frame = nil
      while true # it's just a spinner, no exact timing here
        next_color if @color
        render
        sleep(@interval)
      end
    end

    # idiomatic block syntax support
    if block_given?
      yield
      Whirly.stop
    end

    true
  end

  def self.stop(stop_frame = nil)
    return false unless @enabled
    @thread.terminate if @thread
    render(stop_frame || @stop) if stop_frame || @stop
    @options[:stream].puts if @options[:append_newline]
    @options[:stream].print CLI_COMMANDS[:show_cursor] if @options[:hide_cursor]
    @enabled = false

    true
  end

  def self.reset
    at_exit_handler_registered = defined?(@at_exit_handler_registered) && @at_exit_handler_registered
    instance_variables.each{ |iv| remove_instance_variable(iv) }
    @at_exit_handler_registered = at_exit_handler_registered
  end

  # - - -

  def self.unrender
    return unless @current_frame
    if @options[:position] == "below"
      @options[:stream].print "\n\e[s#{' ' * @current_frame.size}\e[u\e[1A"
    else
      @options[:stream].print "\e[s#{' ' * @current_frame.size}\e[u"
    end
  end

  def self.render(next_frame = nil)
    unrender

    @current_frame = next_frame || @frames.next
    @current_frame = Paint[@current_frame, @color] if @options[:use_color]
    @current_frame += "  #{@status}" if @status

    if @options[:position] == "below"
      @options[:stream].print "\n\e[s#{@current_frame}\e[u\e[1A"
    else
      @options[:stream].print "\e[s#{@current_frame}\e[u"
    end
  end

  def self.initialize_color
    if !defined?(Paint)
      warn "Whirly warning: Using colors requires the paint gem"
    else
      @color = "%.6x" % rand(16777216)
      @color_directions = (0..2).map{ |e| rand(3) - 1 }
    end
  end

  def self.next_color
    @color = @color.scan(/../).map.with_index{ |c, i|
      color_change = rand(@options[:color_change_rate]) * @color_directions[i]
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
