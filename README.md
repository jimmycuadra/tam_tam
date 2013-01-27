# TamTam

**TamTam** is a Ruby gem to parse, navigate, and analyze logs from chat clients. You can query logs in various ways, including finding the most common messages, messages matching a regular expression, or messages containing a particular substring. Logs can also be filtered by date or participants.

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

Create a new logs object with:

``` ruby
logs = TamTam.new
```

To specify a particular adapter (chat client), pass an `adapter` option. If, for any reason, your logs for the given chat client are in a non-standard location, you can also provide the path the logs. These are the defaults, and equivalent to the call above:

``` ruby
logs = TamTam.new(
  adapter: :adium,
  path: "~/Library/Application Support/Adium 2.0/Users/Default/Logs"
)
```

### Filtering logs

Logs can be filtered by participants and date. The following methods are chainable.

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

Limits logs to chats the occurred on a particular date. The date can be supplied as a string (any format Chronic accepts) or a temporal object (`Date`, `Time`, etc.)

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

### Filtering messages

Messages can be filtered by contents. The following methods are chainable along with the log filtering methods.

#### #containing

Limits messages to those containing the provided substring or matching the provided regular expression.

``` ruby
logs.containing("how do you feel about")
logs.containing(/^lol,?\s+/)
```

### Accessing messages

Once you have filtered logs and messages down to the set you want, you can extra the messages themselves as an array of `TamTam::Message` objects with the `messages` method:

``` ruby
logs.messages
```

### Messages

A `TamTam::Message` is a simple data container with the following attributes:

#### #sender

The username of the person who sent the message.

#### #text

The body of the message.

#### #time

The date and time the message was sent.

## License

TamTam is available under the MIT license. See the provided `LICENSE.txt` for details.
