require File.expand_path('../../test_helper', __FILE__)

class AccessorsTest < MiniTest::Spec
  describe "Data testing for Postgresql or Mysql JSON" do
    # Available locales are [:en, :de]
    it "Throws error if save locale other than I18n available locales" do
      page = Page.new title: {ru: 'test'}
      
      assert_equal false, page.valid?
    end

    it "Sets default locales as empty if none given" do
      page = Page.new title: {en: 'test'}
      page.save
      assert_equal true, page.read_attribute("title").keys.include?('de')
    end

    it "Return default locale value from translations" do
      page = Page.new title: {en: 'this is a test', de: 'bite'}
      assert_equal page.title, 'this is a test'
    end

    it "Has method for each locale" do
      page = Page.new title: {en: 'hello', de: 'bite'}
      assert_equal page.title_en, 'hello'
      assert_equal page.title_de, 'bite'
    end

    it "Has method to get all translations" do
      page = Page.new title: {en: 'hello', de: 'bite'}
      translations = page.title_translations
      assert_equal translations, {"en" => 'hello', "de" => 'bite'}
    end
  end
end
