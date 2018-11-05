module SimplyTranslatable
  module Translator
    @translatables = []


    def translates(*attributes)
      adapter = self.connection.instance_variable_get('@config')[:adapter]
      type = :hstore
      postgres  = true
      mysql     = false
      att       = nil
      attributes.each do |attr|
        valid_type = [:hstore, :json, :text, :longtext].include? type
        type  = valid_type ? self.columns.select{|t| t.name==attr.to_s}.first.sql_type_metadata.type : type
        att   = attr unless valid_type
        postgres = (adapter=="postgresql") && (type==:hstore)
        mysql = (adapter=='mysql2') && (type==:json)
      end

      if (postgres ^ mysql)
        @translatables = attributes
      else
        if postgres
          raise ArgumentError, "Translatable fields should be of type 'hstore', instead attribute #{att} has_type #{type}"
        elsif mysql
          raise ArgumentError, "Translatable fields should be of type 'text' or 'longtext', instead attribute #{att} has_type #{type}"
        else
          raise ArgumentError, "Adapter should be mysql2 or postgres"
        end
      end
    end

    def get_translatables
      @translatables
    end
  end
end
