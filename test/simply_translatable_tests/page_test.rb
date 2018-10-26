require File.expand_path('../../test_helper', __FILE__)

class AccessorsTest < MiniTest::Spec
  describe "Postgresql" do
    it "Has translatables data types set to be hstore" do
      begin
        page = Page.new rescue nil
        assert_equal false, page.nil?
      rescue ArgumentError
        assert_equal false, true
      end
    end

    # Available locales are [:en, :de]
    it "Throws error if save locale other than I18n available locales" do
      page = Page.new title: {ru: 'test'}

      assert_equal false, page.valid?
    end

    it "Sets default locales as empty if none given" do
      page = Page.new title: {en: 'test'}
      page.save
      assert_equal true, page.title.keys.include?('de')
    end
  end
end
