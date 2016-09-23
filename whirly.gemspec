# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + "/lib/whirly/version"

Gem::Specification.new do |gem|
  gem.name          = "whirly"
  gem.version       = Whirly::VERSION
  gem.summary       = "TOD2O"
  gem.description   = "TOD2O"
  gem.authors       = ["Jan Lelis"]
  gem.email         = ["mail@janlelis.de"]
  gem.homepage      = "https://github.com/janlelis/whirly"
  gem.license       = "MIT"

  gem.files         = Dir["{**/}{.*,*}"].select{ |path| File.file?(path) && path !~ /^(pkg|data)/ } + %w[
                        data/spinners.json
                      ]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.required_ruby_version = "~> 2.0"
end
