# Talks gem — now your ruby and command-line tools can talk with you

### Build Status ![http://travis-ci.org/gazay/talks](https://secure.travis-ci.org/gazay/talks.png) ![https://codeclimate.com/github/gazay/talks](https://codeclimate.com/github/gazay/talks.png) [![talks API Documentation](https://www.omniref.com/ruby/gems/talks.png)](https://www.omniref.com/ruby/gems/talks)

If you want to HEAR some response from your code or command-line tools, just use this gem.

You can use this gem on MacOS X and on other linux/unix systems with [espeak](http://espeak.sourceforge.net) installed.

Now with support for notifiers through [notifier](https://github.com/fnando/notifier) gem!
Check the notifier's
[README](https://github.com/fnando/notifier/blob/master/README.rdoc) and
find what notifier you want to use - there is support for every OS!

I added in all sections of this readme notes about usage notifier
functionality. And small
[readme](https://github.com/gazay/talks#using-talks-with-growl) about usage with Growl notifier.

### Here is a small [screencast](http://www.youtube.com/watch?v=PaUpwQMBvOY) about talks

Soon we will finish the [wiki](https://github.com/gazay/talks/wiki) and it will be (I hope) delimited and clear for understand.

<a href="https://evilmartians.com/?utm_source=talks">
<img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Sponsored by Evil Martians" width="236" height="54">
</a>

## Why?

### Example

You're running some really long task and you leave the desk to drink some coffee, read a book or surf the internet
and you want to be notified that the task has finished its execution. You don't want to check your machine each minute. With this gem
you can just add a little hook at the end of your code and when the execution ends - you will hear it in voice
that you have chosen from MacOS X `say` function collection or from `espeak` collection.

Now if you forgot power on you sound on machine you can always see
notifications by notifiers like Growl, Kdialog, Knotify, etc. Full list of notifiers is
[here](https://github.com/fnando/notifier/blob/master/README.rdoc).

You can find some examples of `talks` usage in organization [ruby-talks](https://github.com/ruby-talks):

  * [rails-talks](https://github.com/ruby-talks/rails-talks)
  * [bundler-talks](https://github.com/ruby-talks/bundler-talks)
  * [spec-talks](https://github.com/ruby-talks/spec-talks)

Examples from other people:

  * [Autotesting tool on mocha, guard, rake and talks](https://gist.github.com/3150108) by @kossnocorp

## How?

On MacOS X this gem is just using the native MacOS X `say` command line tool.
On linix/unix this gem is using espeak speech synthesis.

For notifications this gem uses [notifier](https://github.com/fnando/notifier/blob/master/README.rdoc) gem.

### In all examples below I've used MacOS X voice types. For espeak you can read section [Using talks with espeak](https://github.com/gazay/talks#using-talks-with-espeak)

### Configuration

You can configure default voices and messages for `talks` with `~/.talksrc` file or with `your_project/.talksrc` file. It should be written in YAML format:

`~/.talksrc`
```yml
default_voice: 'whisper'
engine: 'say'
notifier: 'off'            # if this option passed - you will not receive notifications at all
notifier_options:
  title: 'Not talks'
  image: 'path/to/okay.png'
detach: true               # added ' &' to command line command
notify_by_default: true    # everytime when you call Talks#say - it will call Talks#notify
voices:
  info: 'pipe'
messages:
  info: 'hello'
  warn: 'WE GONNA DIE!!!'
```

You can also do it in your code dynamically through Talks.config instance.

You can configure only the default voice for `say` method and voices and messages for 4 types of talks: `info, warn, success, error`

For command-line commands you can configure default voices and hook messages:

`~/.talksrc`
```yml
bundle:
  voice: 'vicki'
  before_message: 'Bundler again will do all right'
  after_message: "Bundler's job is done here"
  before_notify: 'This will go to notification before `before_message`'
  after_notify: 'This will go to notification after `after_message`'
# notifier: 'off' # this option will turn off notifications for this command
```

You can create your own default preferences for each command-line tool which you want to run with `talks` or `talking` command in front:

`~/.talksrc`
```yml
ls:
  voice: 'bad'
  before_message: 'Now we will see what in the directory'
  after_message: '.'
  before_notify: 'This will go to notification before `before_message`'
  after_notify: 'This will go to notification after `after_message`'
# notifier: 'off' # this option will turn off notifications for this command
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
You can preconfigure messages in your `~/.talksrc` file or you can send options right in the talking command:

```bash
$ talking -v agnes -bm 'We gonna die!' -am 'Not sure if we can hear that' rm -rf ./
# the same
$ talking --voice agnes --before-message 'We...' --after-message 'Not...' rm -rf ./
```
The same with notifications:

```bash
$ talking -v agnes -bn 'We gonna die!' -an 'Not sure if we can hear that' rm -rf ./
# the same
$ talking --voice agnes --before-notify 'We...' --after-notify 'Not...' rm -rf ./
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
Talks.notify 'This will be shown to you by your notifier'
```

`Talks.say` can be customized with type of message and voice by adding options to this method parameters:

```ruby
Talks.say 'Hello like pipe', voice: 'pipe'
Talks.say 'Hello like error', type: :error # the same as using Talks.error
```

All voices which I've found in `say` manual:
```ruby
VOICES = %w(
  agnes albert alex bad bahh bells boing bruce bubbles cellos
  deranged fred good hysterical junior kathy pipe princess ralph
  trinoids vicki victoria whisper zarvox
)
```

### Using talks with espeak

You can configure your `talks` engine even to tell MacOS X to use [espeak](http://espeak.sourceforge.net):

`~/.talksrc`
```yml
engine: 'espeak'
```

Otherwise `talks` will set engine by default. It will be set to `say` on MacOS X and to `espeak` on all other OS-es if command `which espeak` returns non-empty string.

You can even configure your language in espeak (this gem still doesn't support different languages). Voices for espeak:

```ruby
Talks.voices[:espeak]
# =>
  [
    'en+m1', 'en+m2', 'en+m3', 'en+m4', 'en+m5', 'en+m6', 'en+m7',
    'en+f1', 'en+f2', 'en+f3', 'en+f4', 'en+f5', 'en+f6', 'en+f7'
  ]
```

### Using talks with Growl

For [Growl](http://growl.info) you should be a Mac user. And you should have Growl version >= 1.3.

If it's ok for you - you need to do several steps for using talks with Growl:

  * Install the [growlnotify](http://growl.cachefly.net/GrowlNotify-1.3.zip) script

  * Open the Growl Preference Panel (System > Growl) and activate “Listen
    for incoming notifications” and “Allow remote application registration” (in Growl v1.4 present only first option - activate only her)
    options on the Network tab

  * I don't really remember - but maybe you should restart your machine
    after that :)

Now you can use talks with Growl support:

```bash
$: talking -bn 'This is before notification which is shown with growl' ls -la
```

Here is the [screenshot](http://cl.ly/0K3V2F0A1C3O2z1q0923).

## Who?

I did it myself.

### Contributors

  * @gazay

### A lot of thanks

  * @kossnocorp - for idea with notifiers and his pulls.

  * @shime - for grammar fixes in readme and better explanation of my idea.

  * @aderyabin - extended customization of talks is his idea.

  * @brainopia - bro helps me with any idea of mine. He advised me to do command line tool talks.

You can help me with this fun gem and I'll gladly add you here, or above.

## License

The MIT License
