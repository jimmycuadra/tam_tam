# TamTam

[![Build Status](https://travis-ci.org/jimmycuadra/tam_tam.png?branch=master)](https://travis-ci.org/jimmycuadra/tam_tam) [![Code Climate](https://codeclimate.com/github/jimmycuadra/tam_tam.png)](https://codeclimate.com/github/jimmycuadra/tam_tam)

**TamTam** is a Ruby gem to parse, filter, and analyze logs from chat clients. You can filter by various factors: date, participants, or contents.

TamTam is agnostic to operating system and chat client, and ships with adapters for:

* Adium (OS X)

Additional adapters are planned, and welcome via pull request.

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

When you `require "tam_tam"`, all the included adapters are loaded. If you want to save memory and require only the one(s) you need, you may do so:

``` ruby
require "tam_tam/adapters/adium"

logs = TamTam.new
```

If an adapter is not provided when calling `.new`, TamTam defaults to the Adium adapter, or the first registered adapter if the Adium adapter has not been loaded. Details on using custom adapters are included later in this guide.

### Filtering logs

Logs can be filtered by participants and date. All the filter methods are chainable, and return a new `TamTam::Logs` object with the filters applied.

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

### Accessing messages

Once you have filtered logs down to the set you want, you can examine the messages themselves:

``` ruby
messages = logs.messages
```

At this point, the logs on disk are loaded into memory, so the first call to `messages` may take a while, depending on how many logs are being loaded. The messages object is enumerable, and can receive any of the usual iteration and transformation methods.

### Filtering messages

Messages can be filtered by contents. All the filter methods are chainable and return a new `TamTam::MessageSet` object with the filters applied.

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

#### #sent_by

Limits messages to those sent by the provided username.

``` ruby
messages.sent_by("MyFriendJoe")
```

### Analyzing logs

These methods return interesting data about the messages.

#### #by_count

Returns a hash of all the messages grouped by text and the number of times a message with that text was sent. Useful for seeing what messages/phrases you and your chat buddies say most often.

``` ruby
messages.by_count # { "hi" => 4, "how's it going?" => 2 }
```

### Individual messages

When enumerating messages, each message is a `TamTam::Message` object with the following attributes:

#### #sender

The username of the person who sent the message.

#### #text

The body of the message.

#### #time

The date and time the message was sent, as a `Time` object.

## Custom adapters

An adapter is a class that inherits from `TamTam::Adapter` and implements its abstract interface. Once you have defined your adapter class, register it with TamTam:

``` ruby
TamTam.register_adapter(:crazy_chat, CrazyChatAdapter)
```

Adapters must define the following methods:

* `.default_path`
* `#default_matches`
* `#load_messages`
* `#as`
* `#with`
* `#on`
* `#between`

See any of the included adapters for examples.

## Contributing

Issues and pull requests are welcome! If you're opening a pull request, please make sure your branch maintains full test coverage (open `coverage/index.html` after running the specs), and that you don't get any warnings from running `cane`.

## License

TamTam is available under the MIT license. See the provided `LICENSE.txt` for details.
