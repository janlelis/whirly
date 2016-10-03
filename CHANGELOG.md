## CHANGELOG

### Next

- Make paint dependency optional
- Remove pause feature
- Separate configuring into its own method, remember whirly's configuration, can be cleared with the new .reset method
- Introduce "stop" frames to display when spinner is over
- Different newline behaviour; append newline by default after spinner ran. Use position: "below" for old behaviour
- Support multiple frame modes: "linear", "random", "reverse", "swing"
- Update CLI spinners to v0.3.0 (two new spinners)

### 0.1.1

- `non_tty` option to force TTY behaviour (whirly deactivates itself for non TTY by default)
- Allow passing in spinner hashes instead of only spinner names

### 0.1.0

- Initial release

