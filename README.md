# insnergy-api-ruby-client

This is about insnergy API <https://www.insnergy.com/> by ruby interface

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'insnergy-api-ruby-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install insnergy-api-ruby-client

## Usage
You can get the insnergy client by this way

```ruby
client = Insnergy::Client::Token.new(domain: domain, oauth_key: oauth_key, oauth_secert: oauth_secret, refresh_token: refresh_token) 
```

Then you can get `access_token`, `expires_at`

```ruby
client.access_token #=>34092c6d-7548-4c7f-9ede-12a845c4b97
client.expires_at #=> '2017-01-01 10:00:00'
```
Now, you can use the client that's unexpired to do something like `control device` `get widgets infomation` `get power compution`

```ruby
Insnergy::Client::Control.new(client: unexpired_client, device_id: 'RS06000D6F0003BB8B88', action: 'on')

Insnergy::Client::Widgets.new(client: unexpired_client, category: 'outlet')

Insnergy::Client::Power.new(client: unexpired_client, device_ids:['RS06000D6F0003BB8B88','...',...], start_time: this_month_day1, end_time: next_month_day1)
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/insnergy-api-ruby-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

