class SVGGlyph
  attr_accessor :char, :name, :path_d, :width

  def initialize(hash)
    @char   = hash[:char]
    @name   = hash[:name] || ''
    @path_d = hash[:path_d] || ''
    @width  = hash[:width] || 0
  end
end
