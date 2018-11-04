module SimplyTranslatable
  def self.included(klass)
    klass.extend(Translator)
    klass.after_initialize :set_translations

    klass.send(:before_validation, :set_default_locales)
    klass.send(:validate, :validate_locales)
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
      I18n.available_locales.each do |locale| 
        self.read_attribute(trans)[locale.to_s] ||= ''
      end
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
