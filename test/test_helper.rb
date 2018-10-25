$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "simply_translatable"
require "minitest/autorun"

Dir[File.expand_path('../config/**/*.rb', __FILE__)].each { |f| require f }

SimplyTranslatable::Test::Database.connect
