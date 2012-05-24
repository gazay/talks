# Talks gem — now your ruby can talk with you

### Now it works only on MacOS X, soon we'll add support for linux and maybe windows through eSpeak or festival

### This is beta now. Specs are really needed.

If you want to HEAR some response from your code, just use this gem.

Sponsored by Evil Martians <http://evilmartians.com>

## Why?

For example - some really long task and you just get some coffee, read book or surf internet
and you want to know when this task will ends, but don't want to check your mac or terminal each minute -
you can just add small hook in the end of your code and when it will ends - you will hear it with voice that you
choose from MacOS X `say` function collection.

You can find some examples of `talks` usage in organization [ruby-talks](https://github.com/ruby-talks):

  * [rails-talks](https://github.com/ruby-talks/rails-talks)
  * [bundler-talks](https://github.com/ruby-talks/bundler-talks)
  * [spec-talks](https://github.com/ruby-talks/spec-talks)

## How?

This gem just using native MacOS X `say` command line tool.

### Configuration

You can configure default voices and messages for `talks` with `~/.talksrc` file or with `your_project/.talksrc` file. It should be written in YAML format:

`~/.talksrc`
```yml
default_voice: 'whisper'
voices:
  info: 'pipe'
messages:
  info: 'hello'
  warn: 'WE GONNA DIE!!!'
```

The same you can do in your code dynamicly through Talks.config instance.
You can configure now only default voice for `say` method and voices and messages for 4 types of talks: `info, warn, success, error`

For command-line commands you can configure default voices and hook messages:

`~/.talksrc`
```yml
bundle:
  voice: 'vicki'
  before_message: 'Bundler again will do all right'
  after_message: "Bundler's job is done here"
```

You can create your own default preferences for each command-line tool which you want to run with `talks` or `talking` command in front:

`~/.talksrc`
```yml
ls:
  voice: 'bad'
  before_message: 'Now we will see what in the directory'
  after_message: ''
cap:
  ...
vim:
  ...
scp:
  ...
... and etc
```

### Using talks/talking command-line tool

`talks` or `talking` command-line tool wrap your command-line commands with talks hooks:

```bash
$ talking bundle install
```

After that `talks` will wrap execution of this command with voice messages. By default messages will be like 'command_name task started/ended'.
You can preconfigure messages in your `~/.talksrc` file or you can send options right in talking command:

```bash
$ talking -v agnes -bm 'We gonna die!' -am 'Not sure if we can hear that' rm -rf ./
# the same
$ talking --voice agnes --before-message 'We...' --after-message 'Not...' rm -rf ./
```

### Using talks in your code

```bash
$ gem install talks
```

Then in your code you can require and use Talks functions:

```ruby
require 'talks'

Talks.say 'Hello bro!'

# There are 4 types of voice: say or info, warn, success, error
Talks.info 'This is info'
# Talks.warn 'Some text'
# Talks.success 'Some text'
# Talks.error 'Some text'
```

`Talks.say` can be customized with type of message and voice by adding options to executing this method:

```ruby
Talks.say 'Hello like pipe', voice: 'pipe'
Talks.say 'Hello like error', type: :error # the same as using Talks.error
```

All voices which I found in manual for `say`:
```ruby
VOICES = %w(
  agnes albert alex bad bahh bells boing bruce bubbles cellos
  deranged fred good hysterical junior kathy pipe princess ralph
  trinoids vicki victoria whisper zarvox
)
```

## Who?

I did it by myself

### Contributors

  * @gazay

### A lot of thanks

  * @aderyabin - idea of extended customization of talks is his.

  * @brainopia - bro helps me with any my idea. He adviced me to do command line tool talks.

You can help me with this fun gem and I'll gladly add you here, or above

## License

The MIT License

Copyright (c) 2012 gazay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

