require 'active_record'
require 'fileutils'
require 'logger'
require 'yaml'

module SimplyTranslatable
  module Test
    module Database
      extend self

      DB_CONFIG = File.expand_path('../database.yml', __FILE__)
      DRIVER = 'mysql'
      DEFAULT_STRATEGY = :transaction

      def load_db
        require File.expand_path('../../data/data', __FILE__)
      end

      def connect
        puts "CONFIG: #{config[DRIVER]}"
        ::ActiveRecord::Base.establish_connection config[DRIVER]
        load_db

        if in_memory?
          ::ActiveRecord::Migration.verbose = false
          load_schema
          ::ActiveRecord::Schema.migrate :up
          puts "Migrated in memory"
        else
          puts "NOT IN MEMORY"
        end
      end

      def config
        @config ||= YAML::load(File.open(DB_CONFIG))
      end

      def in_memory?
        config[DRIVER]['database'].present?
      end

      def create!
        db_config = config[DRIVER]
        command = case DRIVER
        when "mysql"
          "mysql -u #{db_config['username']} -e 'create database #{db_config['database']} character set utf8 collate utf8_general_ci;' >/dev/null"
        when "postgres", "postgresql"
          "psql -c 'create database #{db_config['database']};' -U #{db_config['username']} >/dev/null"
        end

        puts command
      end

      def drop!
        db_config = config[DRIVER]
        command = case DRIVER
        when "mysql"
          "mysql -u #{db_config['username']} -e 'drop database #{db_config["database"]};' >/dev/null"
        when "postgres", "postgresql"
          "psql -c 'drop database #{db_config['database']};' -U #{db_config['username']} >/dev/null"
        end

        puts command
      end

      def migrate!
        return if in_memory?
        ::ActiveRecord::Migration.verbose = true
        connect
        load_schema
        ::ActiveRecord::Schema.migrate :up
      end

      def cleaning_strategy(strategy, &block)
        DatabaseCleaner.clean
        DatabaseCleaner.cleaning(&block)
        DatabaseCleaner.strategy = DEFAULT_STRATEGY
      end

      def load_schema
        require File.expand_path('../../data/data', __FILE__)
      end
    end
  end
end
