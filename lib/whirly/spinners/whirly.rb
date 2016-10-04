require "json"

module Whirly
  module Spinners
    WHIRLY = {
      "whirly"              => { "proc" => ->(){ [0x1F600 + rand(55) ].pack("U") }, "interval" => 200 },
      "random_dots"         => { "proc" => ->(){ [ 0x2800 + rand(256)].pack("U") }, "interval" => 100 },
      "circled_letter"      => { "proc" => ->(){ [ 0x24B6 + rand(26) ].pack("U") }, "interval" => 120 },
      "circled_number"      => { "proc" => ->(){ [ 0x2460 + rand(9)  ].pack("U") }, "interval" => 120 },
      "star"                => { "proc" => ->(){ [ 0x2729 + rand(34) ].pack("U") }, "interval" => 120 },
      "mahjong"             => { "proc" => ->(){ [0x1F000 + rand(44)].pack("U") }, "interval" => 200 },
      "domino"              => { "proc" => ->(){ [0x1F030 + rand(50)].pack("U") }, "interval" => 200 },
      "vertical_domino"     => { "proc" => ->(){ [0x1F062 + rand(50)].pack("U") }, "interval" => 200 },
      "letters_with_parens" => { "proc" => ->(){ [0x1F110 + rand(26)].pack("U") }, "interval" => 150 },
    }
    WHIRLY.merge! JSON.load(File.read(File.dirname(__FILE__) + "/../../../data/whirly-static-spinners.json"))

    WHIRLY.freeze
  end
end
