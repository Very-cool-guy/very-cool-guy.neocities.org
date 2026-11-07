require "xml"

def find_tag(node, tag)
  node.children.each do |child|
    return child.content if child.name == tag
    find_tag(child, tag)
  end
  "verity"
end

def gen(thing)
  dir = Dir.new(Path[__FILE__].parent.parent/thing)
  file = Path[__FILE__].parent.parent/"#{thing}.html"

  metadata = [] of Array(String)
  dir.each_child do |child_name|
    qual_child_name = dir.path + "/" + child_name
    document = XML.parse(File.read(qual_child_name))
    metadata << [child_name, find_tag(document, "comment").strip, find_tag(document, "h1")]
  end
  metadata = metadata.sort { |x, y| y[1] <=> x[1] } # lexigraphical order fails after year 10000 but i prolly wont live that long
  lines = metadata.map { |data| "<p style=\"text-align:left;\"><a href=\"/#{thing}/#{data[0]}\">#{data[2]}</a><span style=\"float:right;\">#{data[1]}</span></p>" }
  result = lines.join("\n")

  File.open(file, "w") do |target|
    target.print result
  end
end

gen "posts"
gen "reviews"
