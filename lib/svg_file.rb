require 'nokogiri'
require 'svg_font'
require 'enumerable_one'

class SVGFile
  attr_accessor :id
  attr_accessor :content
  attr_reader :width
  attr_reader :height
  attr_reader :x
  attr_reader :y

  def initialize(filename)
    File.open(filename, 'r') do |file|
      doc = Nokogiri::XML(file)
      svg_tag = doc.css('svg').one!
      @x      = svg_tag['x']
      @y      = svg_tag['y']
      @width  = svg_tag['width']
      @height = svg_tag['height']
      @content = svg_tag
    end
  end

  def getFont(font_family, fonts_paths)
    SVGFont.cached_or_new(fonts_paths[font_family])
  end

  def textToPath(fonts_paths, opts = {})
    # <text transform="matrix(1 0 0 1 673.9766 1141.3555)">   ## (scaleX skew1 skew2 scaleY posX posY)
    #   <tspan fill="#FFFFFF" font-family="'ProximaNova-Regular'" font-size="12" x="0" y="0">Lorem ipsum dolor </tspan>
    # </text>
    content.css('text').each do |text_node|
      xml_text = []
      transformation = text_node.attribute('transform').to_s || ''
      match = transformation.match(/matrix\([^\s]+ [^\s]+ [^\s]+ [^\s]+ ([^\s]+) ([^\s]+)\)/)
      x = match.nil? ? 0.0 : match[1].to_f
      y = match.nil? ? 0.0 : match[2].to_f
      if text_node.attribute('font-family') # FIXME: should see if it contains only plain text or tags.
        font_family, asize, fill_color = readFontProperties(text_node)
        font = getFont(font_family, fonts_paths)
        xml_text << font.tspanToPath(text_node.text, x, y, asize, fill_color, opts)
      else
        text_node.css('tspan').each do |span_node|
          # aggiungi gruppo
          font_family, asize, fill_color = readFontProperties(span_node)
          font = getFont(font_family, fonts_paths)
          span_x = x + span_node.attribute('x').to_s.to_f
          span_y = y + span_node.attribute('y').to_s.to_f
          xml_text << font.tspanToPath(span_node.text, span_x, span_y, asize, fill_color, opts)
        end
      end
      text_node.replace("<!-- #{text_node} -->" + xml_text.join("\n"))
    end
  end

  def build_xml
    %{
      <?xml version="1.0" encoding="utf-8"?>
      <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
      #{content.to_xml indent: 2}
    }.gsub(/^ {6}/, '').strip
  end

  def save(filename)
    File.open(filename, 'w') do |file|
      file.write build_xml
    end
  end

  private

  def readFontProperties(node)
    font_family = node.attribute('font-family').to_s.gsub(/'/,'')
    font_family = "Impact" if font_family == '' # FIXME: sane default
    asize = node.attribute('font-size').to_s.to_f
    fill_color = node.attribute('fill').to_s
    [font_family, asize, fill_color]
  end
end
