module SimplyTranslatable
  module Translator
    @@translatables = []


    def translates(*attributes)
      adapter = self.connection.instance_variable_get('@config')[:adapter]
      attributes.each do |att|
        type = self.columns.select{|t| t.name==att.to_s}.first.sql_type_metadata.type
        postgres = (adapter=="postgresql") && (type==:hstore)
        mysql = (adapter=='mysql2') && (type==:json)

        if (postgres ^ mysql)
          unless @@translatables.include?(att)
            @@translatables << att
          end
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
    end

    def get_translatables
      @@translatables
    end
  end
end
