$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "simply_translatable"
require "minitest/autorun"
require "minitest/reporters"
require "minitest/spec"
require 'database_cleaner'

Minitest::Reporters.use!
Dir[File.expand_path('../config/**/*.rb', __FILE__)].each { |f| require f }

# Require all models create for testing
# require File.expand_path('../data/models', __FILE__)

SimplyTranslatable::Test::Database.connect
