require_relative "../lib/whirly"
require "paint"

Whirly::SPINNERS.keys.sort.each{ |spinner_name|
  Whirly.start(spinner: spinner_name, status: spinner_name){
    sleep 1
  }
}
