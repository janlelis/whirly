## CHANGELOG

### 0.2.6

- Update CLI spinners to 1.1.0 (adds "weather" and "christmas")

### 0.2.5

- Update CLI spinners to 1.0.1

### 0.2.4

- Fix bug that the Whirly thread will also stop when main thread throws error
  (patch by @monkbroc)
- New spinner: xberg

### 0.2.3

- Fix bug that in some cases whirly output would be shown on non-ttys
- New spinners: card, cloud, photo, banknote, white_square

### 0.2.2

- More emotions for whirly (the spinner)
- Add cat spinner

### 0.2.1

- Use macOS terminal app compatible ANSI sequences

### 0.2.0

- Make paint dependency optional
- Remove pause feature
- Separate configuring into its own method, remember whirly's configuration, can be cleared with the new .reset method
- Introduce "stop" frames to display when spinner is over
- Different newline behaviour; append newline by default after spinner ran. Use position: "below" for old behaviour
- Support multiple frame modes: "linear", "random", "reverse", "swing"
- Proper unrendering (use unicode-display\_width)
- Introduce spinner packs (to deal with eventual name conflicts, currently: whirly + cli)
- Add more bundled spinners
- Update CLI spinners to v0.3.0 (two new spinners)
- Rename option :use\_color to just :color
- Option to set spinner can also take frames or proc directly
- Add ANSI escape mode option
- Add remove\_after\_stop option

### 0.1.1

- `non_tty` option to force TTY behaviour (whirly deactivates itself for non TTY by default)
- Allow passing in spinner hashes instead of only spinner names

### 0.1.0

- Initial release

