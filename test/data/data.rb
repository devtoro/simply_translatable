IS_POSTGRES = ActiveRecord::Base.connection.instance_values["config"][:adapter]=='postgresql'
IS_MYSQL = ActiveRecord::Base.connection.instance_values["config"][:adapter]=='mysql2'

ActiveRecord::Schema.define do
  if IS_POSTGRES
    enable_extension 'hstore' unless extension_enabled?('hstore')
  end

  create_table :pages, :force => true do |t|
    if IS_POSTGRES
      t.hstore :title
    elsif IS_MYSQL
      t.json :title
    end
  end

  # If uncomented, raises ArgumentError as translatable fields should be of apropriate types
  # hstore for Postgresql
  # text, longtext for Mysql
  # Also uncomment line 5 in models/article.rb
  #
  # create_table :articles, :force => true do |t|
  #   if IS_POSTGRES
  #     t.text :title
  #   elsif IS_MYSQL
  #     t.string :title
  #   end
  # end
end
