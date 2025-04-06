#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'

# Use an environment variable for the username or replace 'yourusername' with your GitHub username
username = ENV['GITHUB_USERNAME'] || 'Najaf-Ali-Imran'
url = "https://github.com/#{username}"

document = Nokogiri::HTML(URI.open(url))
contrib_boxes = document.at_css('div.js-yearly-contributions svg')
contrib_boxes['xmlns'] = "http://www.w3.org/2000/svg"

# Optional: You can set width/height via environment variables or use defaults
width = (ENV['WIDTH'] || (54*13-2)).to_i
height = (ENV['HEIGHT'] || 89).to_i

# Remove any text elements for a cleaner SVG
contrib_boxes.css('text').remove

contrib_boxes['width'] = (width + 11).to_s + 'px'
contrib_boxes['height'] = (height + 11).to_s + 'px'
contrib_boxes.at_css('>g')['transform'] = 'translate(0, 0)'

day_boxes = contrib_boxes.css('g>g')
day_boxes.each_with_index do |box, m|
  box['transform'] = "translate(#{m*((width-53*2)/54+2)}, 0)"
  box.css('rect.day').each_with_index do |col, n|
    col['height'] = ((height-12)/7).to_s
    col['width']  = ((width-53*2)/54).to_s
    col['y']      = col['y'].to_i - (11 - ((height-12)/7)) * col['y'].to_i / 13
  end
end

# Output the SVG content
puts contrib_boxes.to_html
