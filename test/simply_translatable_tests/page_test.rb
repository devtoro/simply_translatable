require File.expand_path('../../test_helper', __FILE__)

class AccessorsTest < MiniTest::Spec
  describe "New page creation" do
    it "New page has no title" do
      page = Page.new
      assert_equal nil, page.title
    end
  end

  describe "Postgresql" do
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
