class Page < ActiveRecord::Base
  include SimplyTranslatable

  translates :title
end
