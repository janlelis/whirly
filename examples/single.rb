require_relative "../lib/whirly"
require "paint"

# Call a single spinner from the command-line

Whirly.start(spinner: $*[0], status: $*[2] || $*[0], color: false){ sleep(($*[1] || 10).to_i) }
