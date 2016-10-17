# Slack Neuralyzer

Slack Neuralyzer is a ruby gem for bulk delete messages and files on Slack channels.

The easiest way to clean up messages and files on Slack.

![](screenshots/neuralyzer.gif)

## Installation

```
$ gem install slack_neuralyzer
```

## Slack token

<a href='https://api.slack.com/web' target='_blank'><img src='screenshots/general_test_token.png' alt='general_test_token' width = '20%' /></a>


##Getting Started

![](screenshots/slack_neuralyzer_demo.gif)

### Show all channel names

`slack_neuralyzer -t <TOKEN> -s`

```ruby
All user direct:
  001. leon
  002. slackbot
  003. cleanerbot

All channels (public):
  001. general
  002. random

All groups (private):
  001. private_channel

All multiparty direct:
  001. mpdm-leon--cleanerbot-1
  002. mpdm-leon--slackbot-1
```

### Delete message(s)

>Rerun below command and use `-e | --execute` to actually delete the message(s).

* Channel

`-C | --channel` `-D | --direct` `-G | --group` `-M | --mpdirect`

```ruby
# Delete all user messages in general channel
slack_neuralyzer -t <TOKEN> -m -C general -u all

# Delete all user messages in leon direct channel
slack_neuralyzer -t <TOKEN> -m -D leon -u all

# Delete all user messages in private_channel groups channel
slack_neuralyzer -t <TOKEN> -m -G private_channel -u all

# Delete all user messages in mpdm-leon--cleanerbot-1 multiparty direct channel
# (can `use slack_neuralyzer -t <TOKEN> -s` to see mpdirect channle name)
slack_neuralyzer -t <TOKEN> -m -M mpdm-leon--cleanerbot-1 -u all
```

* Specific user

`-u | --user`

```ruby
# Delete leon messages in general channel
slack_neuralyzer -t <TOKEN> -m -C general -u leon

# if you want to specific all users, you can type 'all'
slack_neuralyzer -t <TOKEN> -m -C general -u all
```

* Specific Bot

`-b | --bot`

```ruby
# Delete bots messages in general channel
slack_neuralyzer -t <TOKEN> -m -C general -b cleanerbot

# if you want to specific all bots, you can type 'all' (not bot users)
slack_neuralyzer -t <TOKEN> -m -C general -b all
```

* Delete message(s) between two dates

`-A | --after` `-B | --before`

```ruby
# Delete all user messages in general channel at 20160101 to 20161212
slack_neuralyzer -t <TOKEN> -m -C general -u all -A 20160101 -B 20161212
```

* Delete message(s) with specified text

`-R | --regex`

```ruby
# Delete all user messages with hello string in general channel
slack_neuralyzer -t <TOKEN> -m -C general -u all -R hello
```

### Delete file(s)

> File types: all, spaces, snippets, images, gdocs, docs, zips, pdfs

>Rerun below command and use `-e | --execute` to actually delete the message(s).

* Channel

`-C | --channel` `-D | --direct` `-G | --group` `-M | --mpdirect`

```ruby
# Delete all user upload all type file in general channel
slack_neuralyzer -t <TOKEN> -f all -C general -u all

# Delete leon upload all images file in leon direct channel
slack_neuralyzer -t <TOKEN> -f images -D leon -u leon

# Delete all user upload all pdfs file in private_channel groups channel
slack_neuralyzer -t <TOKEN> -f pdfs -G private_channel -u all

# Delete all user upload all zips file in mpdm-leon--cleanerbot-1 multiparty direct channel
# (can `use slack_neuralyzer -t <TOKEN> -s` to see mpdirect channle name)
slack_neuralyzer -t <TOKEN> -f zips -M mpdm-leon--cleanerbot-1 -u all
```

* Specific user and file type

`-u | --user` `-f | --file`

```ruby
# Delete leon upload images file in general channel
slack_neuralyzer -t <TOKEN> -f images -C general -u leon
```

* Delete file between two dates

`-A | --after` `-B | --before`

```ruby
# Delete all user upload all type file in general channel at 20160101 to 20161212
slack_neuralyzer -t <TOKEN> -f all -C general -u all -A 20160101 -B 20161212
```

### Generate log file

`-l | --log`

```ruby
# Generate a log file in the current directory in ./slack_neuralyzer/YYYY-MM-DDTHH:MM:SS
slack_neuralyzer -t <TOKEN> -m -C general -u all -A 20160101 -B 20161212 -l
```


### Rate

`-r | --rate`

```ruby
# Delay between API calls in seconds (default:0.05)
slack_neuralyzer -t <TOKEN> -m -C general -u all -r 0.01
```


### Help

`-h | --help`

```
usage:
    slack_neuralyzer [options]
    See https://github.com/mgleon08/slack_neuralyzer for more information.

options:
    -t, --token TOKEN                Slack API token (https://api.slack.com/web)
    -s, --show                       Show all users, channels, groups and multiparty direct names
    -m, --message                    Specifies that the delete object is messages
    -f, --file TYPE                  Specifies that the delete object is files of a certain type (Type: all, spaces, snippets, images, gdocs, docs, zips, pdfs)
    -C, --channel CHANNEL            Public channel name (e.g., general, random)
    -D, --direct DIRECT              Direct messages channel name (e.g., leon)
    -G, --group GROUP                Private groups channel name
    -M, --mpdirect MPDIRECT          Multiparty direct messages channel name (e.g., mpdm-leon--bot-1 [--show option to see name])
    -u, --user USER                  Delete messages/files from the specific user (if you want to specific all users, you can type 'all')
    -b, --bot BOT                    Delete messages from the specific bot (not bot users, if you want to specific all bots, you can type 'all')
    -A, --after DATE                 Delete messages/files after than this time (YYYYMMDD)
    -B, --before DATE                Delete messages/files before than this time (YYYYMMDD)
    -R, --regex TEXT                 Delete messages with specified text (regular expression)
    -e, --execute                    Execute the delete task
    -l, --log                        Generate a log file in the current directory
    -r, --rate RATE                  Delay between API calls in seconds (default:0.1)
    -h, --help                       Show this message
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [`https://github.com/mgleon08/slack_neuralyzer/pulls`](https://github.com/mgleon08/slack_neuralyzer/pulls)

## Copyright & License

* Copyright (c) 2016 Leon Ji. See [LICENSE.txt](https://github.com/mgleon08/slack_neuralyzer/blob/master/LICENSE.txt) for further details.
* The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).