# SVG Text to Path

## Installing

Clone the repo, the main executable is `./svg-ttp.rb`.

## Testing

Run `./ttp.rb test/assets/test.svg test/assets/test.ttp.svg`.

Check the outputs in a browser.

## TODO

  *  Fix small positioning bugs (hidden parameter in SVG font?)
  *  Translations are problematic to determine position, read SVGO source: https://github.com/svg/svgo/blob/master/plugins/_transforms.js
  *  Indent the output
  *  Directory structure
  *  Test suite
