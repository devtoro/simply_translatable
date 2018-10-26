require "simply_translatable/version"

module SimplyTranslatable
  def self.included(klass)
    klass.extend(Translator)

    klass.send(:validate, :validate_locales)
    klass.send(:before_save, :set_default_locales)
  end


  module Translator
    @@translatables = []


    def translates(*attributes)
      adapter = self.connection.instance_variable_get('@config')[:adapter]
      attributes.each do |att|
        type = self.columns.select{|t| t.name==att.to_s}.first.sql_type_metadata.type

        if (adapter=="postgresql") && (type==:hstore)
          @@translatables << att
        else
          raise ArgumentError, "Translatable fields should be of type 'hstore', instead attribute #{att} has_type #{type}"
        end
      end
    end

    def get_translatables
      @@translatables
    end
  end

  private

  def validate_locales
    self.class.get_translatables.each do |trans|
      if (self.send(trans).keys & I18n.available_locales.map(&:to_s)).empty?
        errors.add(trans, "Trying to save invalid locale. Please check I18n available locales.")
      end
    end
  end

  def set_default_locales
    self.class.get_translatables.each do |trans|
      I18n.available_locales.each {|locale| self.send(trans)[locale.to_s] ||= ''}
    end
  end
end
