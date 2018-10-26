$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "minitest/autorun"
require "minitest/reporters"
require "minitest/spec"
require 'database_cleaner'
require 'pry'

Minitest::Reporters.use!
Dir[File.expand_path('../config/**/*.rb', __FILE__)].each { |f| require f }
# Require all models create for testing
# require File.expand_path('../data/models', __FILE__)

# binding.pry
SimplyTranslatable::Test::Database.connect
DatabaseCleaner.strategy = :transaction

# Require here in order to have DB connection
require "simply_translatable"

# Set up I18n configuration
I18n.enforce_available_locales = true
I18n.available_locales = [ :en, :de ]

# Require all models here in order to have all needed functionality
Dir[File.expand_path('../data/models/*.rb', __FILE__)].each { |f| require f }


class MiniTest::Spec
  before :each do
    DatabaseCleaner.start
    I18n.locale = I18n.default_locale = :en
  end

  after :each do
    DatabaseCleaner.clean
  end

  ActiveRecord::Base.class_eval do
    class << self
      def index_exists?(index_name)
        connection.indexes(table_name).any? { |index| index.name == index_name.to_s }
      rescue ActiveRecord::StatementInvalid
        false
      end
    end
  end
end
