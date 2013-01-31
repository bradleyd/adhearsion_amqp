AdhearsionAmqp
==========================

adhearsion-amqp is an adhearsion plugin to publish messages to an AMQP host.

Features
--------

 * publish

Requirements
------------

* Adhearsion 2.0+
* RabbitMQ server

Install
-------

Add `adhearsion_amqp` to your Adhearsion app's Gemfile.

Configuration
-------------

In your Adhearsion app configuration file, add the following values:

```ruby
Adhearsion.config.adhearsion_amqp do |config|
  config.host        = "AMQP host"
  config.port        = "AMQP port".to_i
  config.queue       = "AMQP Queue to bind to"
  config.routing_key = "AMQP routing key for exchange"
end
```

Usage
-----

```ruby
# encoding: utf-8 
 
class ClassicController < Adhearsion::CallController 
  before_call do 
    call.register_event_handler do |event| 
      publish(event) 
    end 
  end 
 
  def run 
    answer 
    play 'tt-weasels' 
    hangup 
  end 
end
```

Author
------

[Brad Smith](https://github.com/bradleyd)

Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  * If you want to have your own version, that is fine but bump version in a commit by itself so I can ignore when I pull
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (C) 2012 Adhearsion Foundation Inc.
Released under the MIT License - Check [License file](https://github.com/adhearsion/adhearsion-drb/blob/master/LICENSE)
