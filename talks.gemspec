# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "talks/version"

Gem::Specification.new do |s|
  s.name        = "talks"
  s.version     = Talks::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['gazay']
  s.email       = ['alex.gaziev@gmail.com']
  s.homepage    = "https://github.com/ruby-talks/talks"
  s.summary     = %q{Gem for talking ruby code and command-line tools}
  s.description = %q{This gem can be used for wraping command-lines with `talks` command or for adding hooks in ruby code which would tell you something}

  s.rubyforge_project = "talks"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
