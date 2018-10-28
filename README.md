# SimplyTranslatable

This gem is still under development..

So far tested only for POSTGRESQL and MySQL.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simply_translatable', git: 'https://github.com/devtoro/simply_translatable.git'
```

And then execute:

    $ bundle

## Usage

Working exclusively with ActiveRecord.

For POSTGRESQL, all translatable attributes should be of type hstore. For MySQL, all translatable attributes should be of type json. Otherwise an ArgumentError is raised. Once the appropriate migration is run, we can store the translations in a Hash format as expected for hstore/json type.

Your migrations should be like the following one:

for POSTGRESQL:
    create_table :articles do |t|
      t.hstore :title
    end
for MySQL (Version >= 8.0):
    create_table :articles do |t|
      t.json :title
    end

Inside your model include the SimplyTranslatable module and define the attributes you need to store translations with the translates method:

    class Article < ActiveRecord::Base
      include SimplyTranslatable

      # title must be of type hstore
      translates :title
    end

Let's assume our model name is Article and the translatable attribute is the title

    article = Article.new title: {en: 'Some text', el: 'Κείμενο για μετάφραση'}

Following instance methods are available:

    article.title_translations # Returns all translations stored in db
    article.title # Return the translation for the default locale
for each available locale, a method is available. If we have the following available locales [:en, :el] we can get each translation as follows:

    article.title_en # en translation
    article.title_el # el translation


It should work for MySQL database, for text data type if attribute is serialised as JSON:

  migration:
    create_table :articles do |t|
      t.text :title
    end

    class Article < ActiveRecord::Base
      include SimplyTranslatable

      serialize :title, JSON
      translates :title
    end

But is not tested yet.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/devtoro/simply_translatable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
