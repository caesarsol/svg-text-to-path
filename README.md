# SVG Text to Path

## Installing

0. Clone the repo: `git clone https://github.com/caesarsol/svg-text-to-path.git`
0. Then install the gem with `rake install`.
0. Your `svg-ttp` executable should now be in your PATH.
0. Usage: `svg-ttp input.svg output.svg`

## Testing

0. Run `./bin/svg-ttp test/assets/test.svg test/assets/test.ttp.svg`.
0. Check the outputs in a browser.

## TODO

  *  Fix small positioning bugs (hidden parameter in SVG font?)
  *  Different and more fonts, search them also from `~/.fonts-svg-ttp/`
  *  More options in the CLI, i.e. fonts_dir
  *  Translations are problematic to determine position, read SVGO source: https://github.com/svg/svgo/blob/master/plugins/_transforms.js
  *  Indent the output
  *  Directory structure inside *lib/*
  *  Test your code, what the heck!
