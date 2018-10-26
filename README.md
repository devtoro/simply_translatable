# SimplyTranslatable

This gem is still under development..

So far tested only for postgresql.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simply_translatable', git: 'https://github.com/devtoro/simply_translatable.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simply_translatable

## Usage

Working exclusively with ActiveRecord. 

For postgresql, all attributes that we need to store translations, should be of type hstore. Otherwise an ArgumentError is raised. Once the appropriate migration is run, we can store the translations in a Hash format as expected for hstore.

Inside your model include the SimplyTranslatable module:

    class Article < ActiveRecord::Base
      include SimplyTranslatable
      
      # title must be of type hstore
      translates :title
    end

Let's assume our model name is Article and the translatable attribute is the title

    article = Article.new

Following instance methods are available:

    article.title_translations # Returns all translations stored in db
    article.title # Return the translation for the default locale
for each available locale, a method is avialable. If we have to available locales [:en, :el] we can get each translation as follows:

    article.title_en # en translation
    article.title_el # el translation


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/simply_translatable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
