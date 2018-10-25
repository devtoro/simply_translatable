
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "simply_translatable/version"

Gem::Specification.new do |s|
  s.name          = "simply_translatable"
  s.version       = SimplyTranslatable::VERSION
  s.authors       = ["Manolis Tsilikidis"]
  s.email         = ["manolistsilikidis@gmail.com"]

  s.summary       = %q{A simple gem to store translation in database}
  s.description   = s.summary
  s.homepage      = "https://github.com/devtoro/simply_translatable.git"
  s.license       = "MIT"

  s.files        = Dir['{lib/**/*,[A-Z]*}']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.required_ruby_version = '>= 2.3.3'

  s.add_dependency 'activerecord', '>= 4.2', '< 5.3'
  s.add_dependency 'activemodel', '>= 4.2', '< 5.3'
  s.add_dependency 'request_store', '~> 1.0'

  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-reporters'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
end
