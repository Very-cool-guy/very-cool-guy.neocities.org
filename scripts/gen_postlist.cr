require "xml"

post_dir = Dir.new(Path[__FILE__].parent.parent/"posts")
post_html = Path[__FILE__].parent.parent / "posts.html"

def find_tag(node, tag)
  node.children.each do |child|
    return child.content if child.name == tag
    find_tag(child, tag)
  end
  "verity"
end

metadata = [] of Array(String)
post_dir.each_child do |child_name|
  qual_child_name = post_dir.path + "/" + child_name
  document = XML.parse(File.read(qual_child_name))
  metadata << [child_name, find_tag(document, "comment").strip, find_tag(document, "h1")]
end
metadata = metadata.sort { |x, y| y[1] <=> x[1] } # lexigraphical order fails after year 10000 but i prolly wont live that long
lines = metadata.map { |data| "<p style=\"text-align:left;\"><a href=\"/posts/#{data[0]}\">#{data[2]}</a><span style=\"float:right;\">#{data[1]}</span></p>" }
result = lines.join("\n")

File.open(post_html, "w") do |file|
  file.print result
end
