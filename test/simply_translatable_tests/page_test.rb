require File.expand_path('../../test_helper', __FILE__)

class AccessorsTest < MiniTest::Spec
  describe "New page creation" do
    it "Has no title" do
      page = Page.new
      assert_equal nil, page.title
    end
  end
end
