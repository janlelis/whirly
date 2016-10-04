require_relative "../lib/whirly"
require "paint"

# Call a single spinner from the command-line

Whirly.start(spinner: $*[0], use_color: false){ sleep(($*[1] || 10).to_i) }
