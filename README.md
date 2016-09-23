# Whirly [![[version]](https://badge.fury.io/rb/whirly.svg)](http://badge.fury.io/rb/whirly)  [![[travis]](https://travis-ci.org/janlelis/whirly.png)](https://travis-ci.org/janlelis/whirly)

Whirly terminal spinner for Ruby, influenced by [ora](https://github.com/sindresorhus/ora), includes [cli-spinners](https://github.com/sindresorhus/cli-spinners).

ALPHA RELEASE FOR EURUKO

## Setup

Add to your `Gemfile`:

```ruby
gem 'whirly'
gem 'paint' # makes whirly colorful (recommended)
```

## Usage

### Basic Usage

```ruby
Whirly.start do
  Whirly.status = "Working on it…"
  sleep 3
  Whirly.status = "Almoste done…
  sleep 2
end
```

### Non-Block Syntax, World Spinner

```ruby
Whirly.start spinner: "world"
Whirly.status = "Working on it…"
sleep 3
Whirly.status = "Almoste done…"
Whirly.stop
```

### No Colors, Pong Spinner, Initial Status

```ruby
Whirly.start spinner: "pong", use_color: false, status: "The Game of Pong" do
  sleep 10
end
```

### Slower Interval, Don't Hide Cursor

```ruby
Whirly.start spinner: "clock", interval: 1000, hide_cursor: false do
  sleep 5
end
```

## Included Spinners & Custom Spinners

- See `data/cursors.json`
- Spinners are either an Array of frames or an enumerator [...]
- Extra fun spinners :random_character, :random_emoticon (SOON)

## Remarks, Troubleshooting, Caveats

- Interval is milliseconds, but don't rely on exact timing
- Will not do anything if stream is not a real console
- Colors not working? Be sure to include the [paint](https://github.com/janlelis/paint/) gem
- Don't set very short intervals (or it might affect performance substantly)

## MIT License

- Copyright (C) 2016 Jan Lelis <http://janlelis.com>. Released under the MIT license.
- Contains data from cli-spinners:  MIT License, Copyright (c) Sindre Sorhus <sindresorhus@gmail.com> (sindresorhus.com)
