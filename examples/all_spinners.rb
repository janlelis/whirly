require_relative "../lib/whirly"
require "paint"

# Demonstrates all available spinners

if spinner_pack = $*[0]
  constants = [spinner_pack.upcase]
else
  constants = Whirly::Spinners.constants
end

constants.each{ |spinner_pack|
  puts
  puts Paint[spinner_pack, :underline]
  puts
  Whirly::Spinners.const_get(spinner_pack).keys.sort.each{ |spinner_name|
    Whirly.start(spinner: spinner_name, status: spinner_name){
      sleep 1.5
    }
  }
}
