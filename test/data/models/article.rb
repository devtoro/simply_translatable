# Here title is of wrong type, so an exception should be raised
class Article < ActiveRecord::Base
  include SimplyTranslatable

  # translates :title
end
