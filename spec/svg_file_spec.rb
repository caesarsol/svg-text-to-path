require 'svg_file'

RSpec.describe SVGFile do
  it "initializes and reads test file" do
    svg = SVGFile.new 'test/assets/test.svg'
    group_id = svg.content.at_css('g')['id']
    expect(group_id).to eq("Path")
  end
end
