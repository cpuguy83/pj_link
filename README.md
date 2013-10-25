# PjLink

A simple library for communicating over the PJLink protocol

## Installation

Add this line to your application's Gemfile:

    gem 'pj_link'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pj_link

## Usage

```ruby
projector = PjLink::Client.new '1.1.1.1', 'super_secret_password'
projector.power_status
```

You can also use this without a password if your projector allows you too.

Available commands are:
 - power_on
 - power_off
 - power_status
 - video_mute_on
 - video_mute_off
 - mute_on
 - mute_off
 - av_mute_on
 - av_mute_off
 - inputs
 - set_input
 - mute_status
 - lamp_hours
 - device_name
 - manufacturer
 - product
 - pjlink_class
 - other_info

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
