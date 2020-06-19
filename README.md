# RailsModelValidator

Rails `validates_*` DSL with complex `if:`, `unless:` and `on:` conditions becomes ugly very quick. This micro gem introduces base PORO class which aims to replace standard Rails DSL and still allows to use default ActiveModel validations for individual checks.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_model_validator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_model_validator

## Usage

The following piece of code:

```ruby
validate :subject_essential_attributes_present,   on: :update, if: :move_to_open_status?
validate :essential_attributes_present,           on: :update, if: :move_to_open_status?
validate :reviewed_attributes_present,            on: :update, if: :move_to_review_required_status?
validate :creator_email_present, on: :update,                  if: :closing?

# ... 15+ lines

def subject_essential_attributes_present
  errors.add(:name, :invalid) if name.to_s.blank?
  # ... 20+ lines
end
```

May be transformed into one or several simple, clean and reusable classes:

```ruby
class SubjectEssentialAttributesValidator < RailsModelValidator
  def validate
    validate_personal_attributes_present
    validate_there_are_not_too_much_images
  end

  private

  def validate_personal_attributes_present
    validate_presence_of(:name, :age, :gender)
  end

  def validate_there_are_not_too_much_images
    errors.add(:images, :too_many) if subject.images.count > 10
  end
end
```

Rails [custom validators](https://guides.rubyonrails.org/active_record_validations.html#custom-validators) are little more verbose.

Base class also provides `#create?` and `#update?` methods which will work in ActiveRecord context.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rails_model_validator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RailsModelValidator project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rails_model_validator/blob/master/CODE_OF_CONDUCT.md).
