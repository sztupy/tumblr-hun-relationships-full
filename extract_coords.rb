#!/usr/bin/env ruby

svg_width = 0
svg_height = 0

translate_x = 0
translate_y = 0

data = []

ARGF.each_line do |line|
  if line =~ /<svg width="([0-9]*)pt" height="([0-9]*)pt"/
    svg_width = $1.to_i
    svg_height = $2.to_i
  elsif line =~ /<g .* transform=".*translate\(([0-9.-]*) ([0-9.-]*)\)">/
    translate_x = $1.to_f
    translate_y = $2.to_f
  elsif line =~ /<text .* x="([-.0-9]*)" y="([-.0-9]*)" [^>]*>(.*)<\/text>/
    x = $1.to_f
    y = $2.to_f
    name = $3.gsub('&#45;','-')

    data << [
      name.gsub('_','-').gsub(/^-/,''),
      (x + translate_x)/svg_width,
      (y + translate_y)/svg_width
    ]
  end
end

puts 'var blogs = {'
puts data.sort_by{|d| d[0]}.map{|d| "\"%s\":[%07f,%07f]" % d}.join(",")
puts '}'
