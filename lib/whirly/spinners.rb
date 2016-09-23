require "json"

module Whirly
  SPINNERS = JSON.load(File.read(File.dirname(__FILE__) + "/../../data/spinners.json"))
  SPINNERS["whirly"] = { "proc" => ->(){ [0x1F600 + rand(55)].pack("U") }, "interval" => 200 }
end
