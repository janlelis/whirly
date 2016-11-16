require_relative '../lib/whirly'
require 'paint'

# Lightning talk at EuRuKo 2016

# # # Whirly

print "\033c"
puts Paint["Whirly", :underline]

Whirly.start status: 'Generating something huge…' do
  sleep 15
  Whirly.status = "(actually it's just `sleep 15`)"
  sleep 15
  Whirly.status = "Almost done…"
  sleep 3
  Whirly.status = "10 more seconds!"
  sleep 10
end

puts
puts
puts
puts "Done"
sleep 5

# # # Earth

print "\033c"
puts Paint["Earth Spinner", :underline]

Whirly.start spinner: "earth"
Whirly.status = "Travelling…"
sleep 9
Whirly.stop

puts
puts
puts
puts "Done"
sleep 5

# # # Pong Game

print "\033c"
puts Paint["Pong", :underline]

Whirly.start spinner: "pong", color: false, status: "Two computers in a game of Pong" do
  sleep 9
end

puts
puts
puts
puts "Done"
sleep 5

# # # Ticking Clock

print "\033c"
puts Paint["Clock", :underline]

Whirly.start spinner: "clock", interval: 1000 do
  sleep 12
end

puts
puts
puts
puts "Time is over"

# # # URL

print "\033c"
puts Paint["Get WHIRLY", :bold]

Whirly.start spinner: "whirly", status: "https://github.com/janlelis/whirly" do
  sleep 60
end
