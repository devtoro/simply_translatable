require "simply_translatable/version"

module SimplyTranslatable
  def self.included(klass)
    klass.extend(Translator)
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
end
