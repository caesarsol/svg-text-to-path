require 'svg_glyph'
require 'enumerable_one'

class SVGFont
  @@font_files_cache = {}
  attr_accessor :id

  def initialize(filepath)
    puts "Loading font #{filepath}"
    load(File.open(filepath))
  end

  def self.cached_or_new(filepath)
    @@font_files_cache[filepath] ||= self.new(filepath)
  end

  def load(file)
    xml = Nokogiri::XML(file)
    @glyphs = Hash.new(SVGGlyph.new(char: '�', path_d: ''))
    # <svg height="100%" width="100%" xmlns="http://www.w3.org/2000/svg">
    #   <defs>
    #     <font horiz-adv-x="368" id="MMTextWebTT-Regular">
    #       <font-face .../>
    #       <missing-glyph .../>
    #       <glyph .../>
    #       <glyph .../>
    #     </font>
    #   </defs>
    # </svg>
    xml.css('font').one!.tap do |font|
      @id            = font.attribute('id').to_s
      @default_width = font.attribute('horiz-adv-x').to_s.to_f

      font.css('font-face').one!.tap do |fontface|
        @units_per_em = fontface.attribute('units-per-em').to_s.to_f
        @bbox         = fontface.attribute('bbox').to_s.split(/[,\s]+/).map(&:to_i) # lower left x,y; upper right x,y
        @ascent       = fontface.attribute('ascent').to_s.to_f
        @descent      = fontface.attribute('descent').to_s.to_f
        @font_stretch = fontface.attribute('font-stretch').to_s.tap{ |v| v << 'normal' if v.length == 0 }
        @width_correction = {
          :'normal'          => 0,
          :'wider'           => 0,
          :'narrower'        => 0,
          :'ultra-condensed' => 0,
          :'extra-condensed' => 0,
          :'condensed'       => -50,
          :'semi-condensed'  => 0,
          :'semi-expanded'   => 0,
          :'expanded'        => 0,
          :'extra-expanded'  => 0,
          :'ultra-expanded'  => 0,
          :'inherit'         => 0,
        }[@font_stretch.to_sym]
      end

      font.css('missing-glyph').one!.tap do |node|
        @glyphs.default = SVGGlyph.new(
          char:     '�',
          name:     'missing-glyph',
          path_d:   node.attribute('d').to_s,
          width:    node.attribute('horiz-adv-x').to_s.to_f || @default_width
        )
      end

      font.css('glyph').each do |node|
        char = node.attribute('unicode').to_s
        if char != ''
          @glyphs[char] = SVGGlyph.new(
            char:   char,
            name:   node.attribute('glyph-name').to_s,
            path_d: node.attribute('d').to_s,
            width:  node.attribute('horiz-adv-x').to_s.to_f || @default_width
          )
        end
      end

      font.css('hkern').each do |node|
      end
    end
  end

  def getGlyph(char)
    @glyphs[char]
  end

  def tspanToPath(text, x, y, asize, fill_color, opts)
    size = asize / @units_per_em
    previous_glyph = nil
    advance = 0
    groupTag(text, x, y, size, fill_color) do |group_content|
      text.chars.map(&method(:getGlyph)).each do |glyph|
        advance += previous_glyph.width + @width_correction if previous_glyph
        group_content << pathTag(glyph, advance)
        group_content << debugBox(glyph, advance, @ascent + @descent) if opts[:debug]
        previous_glyph = glyph
      end
    end
  end

  private

  # def tspanToGlyphs(text, asize, fill_color)

  def groupTag(text, x, y, size, fill_color, &block)
    content = []
    block.call(content)
    %{
      <g data-tspan="#{text}" fill="#{fill_color}" transform="translate(#{x}, #{y}) scale(#{size})">
        #{content.join("\n")}
      </g>
    }
  end

  def pathTag(glyph, advance)
    %{<path data-glyph="#{glyph.char}" transform="translate(#{advance}) scale(1, -1)" d="#{glyph.path_d}" />}
  end

  def debugBox(glyph, advance, height)
    %{
      <rect transform="translate(#{advance}) scale(1 -1)" width="#{glyph.width}" height="#{height}" fill="transparent" stroke="blue" stroke-width="5" />
    }
  end
end
