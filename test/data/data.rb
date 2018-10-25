IS_POSTGRES = ActiveRecord::Base.connection.instance_values["config"][:adapter]=='postgresql'
IS_MYSQL = ActiveRecord::Base.connection.instance_values["config"][:adapter]=='mysql'

ActiveRecord::Schema.define do
  if IS_POSTGRES
    enable_extension 'hstore' unless extension_enabled?('hstore')
  end

  create_table :pages, :force => true do |t|
    if IS_POSTGRES
      t.hstore :title
    elsif IS_MYSQL
      t.text :title
    end
  end
end
