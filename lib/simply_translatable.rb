require "simply_translatable/version"

module SimplyTranslatable
  def self.included(klass)
    klass.extend(Translator)
    klass.after_initialize :set_translations

    klass.send(:validate, :validate_locales)
    klass.send(:before_save, :set_default_locales)
  end

  def method_missing(m, *args, &block)
    attribute = m.to_s.gsub('translatable_', '').to_sym
    if self.class.get_translatables.include?(attribute)
      value = self.read_attribute attribute
      value[I18n.locale.to_s] || value[I18n.locale]
    else
      super
    end
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
      if (self.read_attribute(trans).keys & I18n.available_locales.map(&:to_s)).empty?
        errors.add(trans, "Trying to save invalid locale. Please check I18n available locales.")
      end
    end
  end

  def set_default_locales
    self.class.get_translatables.each do |trans|
      I18n.available_locales.each {|locale| self.read_attribute(trans)[locale.to_s] ||= ''}
    end
  end

  def set_translations
    klass = self
    self.class.get_translatables.each do |tr|
      define_singleton_method tr do
        klass.send("translatable_#{tr}")
      end

      define_singleton_method "#{tr}_translations" do
        self.read_attribute tr
      end

      I18n.available_locales.each do |locale|
        define_singleton_method "#{tr}_#{locale}" do
          value = klass.read_attribute tr
          value[locale.to_s] || value[locale]
        end
      end
    end
  end
end
