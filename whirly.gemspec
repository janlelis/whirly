# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + "/lib/whirly/version"

Gem::Specification.new do |gem|
  gem.name          = "whirly"
  gem.version       = Whirly::VERSION
  gem.summary       = "Whirly: The friendly terminal spinner"
  gem.description   = "Simple terminal spinner with support for custom spinners. Includes spinners from npm's cli-spinners."
  gem.authors       = ["Jan Lelis"]
  gem.email         = ["mail@janlelis.de"]
  gem.homepage      = "https://github.com/janlelis/whirly"
  gem.license       = "MIT"

  gem.files         = Dir["{**/}{.*,*}"].select{ |path| File.file?(path) && path !~ /^(pkg|data)/ } + %w[
                        data/cli-spinners.json
                        data/whirly-static-spinners.json
                      ]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "unicode-display_width", "~> 1.1"

  gem.required_ruby_version = "~> 2.0"
end
