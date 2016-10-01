require_relative "../lib/whirly"
require "paint"

Whirly.configure(spinner: "dots", stop: "✔️")

Whirly.start status: "Processing" do
  sleep 2
end

Whirly.start status: "More processing" do
  sleep 2
end

Whirly.start status: "Even more processing" do
  sleep 2
end

puts "Done"