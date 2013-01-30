# TamTam

[![Build Status](https://travis-ci.org/jimmycuadra/tam_tam.png?branch=master)](https://travis-ci.org/jimmycuadra/tam_tam)

**TamTam** is a Ruby gem to parse, navigate, and analyze logs from chat clients. You can query logs in various ways, including finding the most common messages, messages containing a particular substring, or messages matching a regular expression. Logs can also be filtered by date or participants.

TamTam is agnostic to operating system and chat client, and ships with adapters for:

* Adium (OS X)

Additional adapters are welcome via pull request.

## Installation

On the command line:

``` bash
gem install tam_tam
```

Or via Bundler:

``` ruby
gem "tam_tam"
```

## Usage

### Instantiation

Create a new logs object with the default Adium adapter:

``` ruby
require "tam_tam"
logs = TamTam.new
```

Specify an adapter:

```ruby
logs = TamTam.new(adapter: :messages)
```

List all registered adapters:

``` ruby
TamTam.adapters # [:adium, :messages]
```

Use a non-standard path for log files:

``` ruby
TamTam.new(path: "/path/to/logs")
```

#### Limiting the loaded adapters

When you require `tam_tam`, all the included adapters are loaded. If you want to save memory and require only the one(s) you need, you may do so:

``` ruby
require "tam_tam/adapters/adium"

logs = TamTam.new
```

Details on using custom adapters are included later in this guide.

### Filtering logs

Logs can be filtered by participants and date. The following methods are chainable and modify the object in place.

#### #as

Limits logs to the account you were chatting as. Accepts any number of string arguments with the username of the account.

``` ruby
logs.as("MyAIMScreenName")
logs.as("MyAIMScreenName", "google.talk@gmail.com")
```

#### #with

Limits logs to the account you were chatting with. Like `as`, accepts any number of string arguments with the username of the account.

``` ruby
logs.with("MyFriendJoe")
logs.with("MyFriendJoe", "my.secret.crush@gmail.com")
```

#### #on

Limits logs to chats that occurred on a particular date. The date can be supplied as a string (any format [Chronic](https://github.com/mojombo/chronic "Chronic") accepts) or a temporal object (`Date`, `Time`, etc.)

``` ruby
logs.on("September 23, 2013")
logs.on(Date.today)
logs.on(Time.now)
```

#### #between

Limits logs to chats that occurred within a date range. Takes two dates, which, like `on`, can be strings or temporal objects.

``` ruby
logs.between(5.days.ago, Date.today)
```

### Chaining the same method multiple times

Note that if you call the same filter method more than once, you may not get any results because it's effectively creating a logical AND. To illustrate:

``` ruby
# Logs as MyAIMScreenName OR google.talk@gmail.com
logs.as("MyAIMScreenName", "google.talk@gmail.com")

# Logs as MyAIMScreenName AND google.talk@gmail.com (no matches)
logs.as("MyAIMScreenName").as("google.talk@gmail.com")
```

### Accessing messages

Once you have filtered logs down to the set you want, you can examine the messages themselves:

``` ruby
logs.messages
```

At this point, the logs on disk are loaded into memory, so the first call to `messages` may take a while, depending on how many logs are being loaded. The messages object is enumerable, and can receive any of the usual iteration and transformation methods.

### Filtering messages

Messages can be filtered by contents. The following methods are chainable and modify the messages object in place:

#### #including

Limits messages to those that include the provided substring.

``` ruby
messages.including("how do you feel about")
```

#### #matching

Limits messages to those that match the provided regular expression.

``` ruby
messages.matching(/^lol,?\s+/)
```

### Individual messages

When enumerating messages, each message is a simple object with the following attributes:

#### #sender

The username of the person who sent the message.

#### #text

The body of the message.

#### #time

The date and time the message was sent, as a `Time` object.

## Custom adapters

An adapter is a class that inherits from `TamTam::Adapter` and implements a few specific methods. Once you have defined your adapter class, register it with TamTam:

``` ruby
TamTam.register_adapter(:crazy_chat, CrazyChatAdapter)
```

Adapters must define the following methods:

* `.default_path`
* `.default_matches`
* `#as`
* `#with`
* `#on`
* `#between`
* `#messages`

See the in-code documentation for `TamTam::Adapter` for details.

## Contributing

Issues and pull requests are welcome! If you're opening a pull request, please make sure your branch maintains full test coverage (open `coverage/index.html` after running the specs), and that you don't get any warnings from running `cane`.

## License

TamTam is available under the MIT license. See the provided `LICENSE.txt` for details.
