require "simply_translatable/version"

module SimplyTranslatable
  def self.included(klass)
    klass.extend(Translator)

    klass.send(:validate, :validate_locales)
  end


  module Translator
    @@translatables = []


    def translates(*attributes)
      attributes.each do |att|
        @@translatables << att
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
end
