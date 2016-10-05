require_relative "../lib/whirly"
require "paint"

system "clear"

Whirly::Spinners::WHIRLY.keys.sort.each{ |spinner_name|
  Whirly.start(spinner: spinner_name, status: spinner_name, append_newline: false, ansi_escape_mode: "line", remove_after_stop: true){
    sleep 1.5
  }
}

system "exit"
