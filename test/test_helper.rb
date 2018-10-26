$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "simply_translatable"
require "minitest/autorun"
require "minitest/reporters"
require "minitest/spec"
require 'database_cleaner'
require 'pry'

Minitest::Reporters.use!
Dir[File.expand_path('../config/**/*.rb', __FILE__)].each { |f| require f }
Dir[File.expand_path('../data/models/*.rb', __FILE__)].each { |f| require f }
# Require all models create for testing
# require File.expand_path('../data/models', __FILE__)

# binding.pry
SimplyTranslatable::Test::Database.connect
DatabaseCleaner.strategy = :transaction

class MiniTest::Spec
  before :each do
    DatabaseCleaner.start
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

      def index_exists_on?(column_name)
        connection.indexes(table_name).any? { |index| index.columns == [column_name.to_s] }
      rescue ActiveRecord::StatementInvalid
        false
      end

      def unique_index_exists_on?(*columns)
        connection.indexes(table_name).any? { |index| index.columns == columns && index.unique }
      end
    end
  end
end
