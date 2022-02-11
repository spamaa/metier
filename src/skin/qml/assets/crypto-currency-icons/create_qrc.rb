# Generates a helpfull list for importing the icons from the package via qrc urls.
#                                                               -wigz

puts "+" * 70
puts "Crypto icon qrc generator started..."
puts "+" * 70



svg_filenames = [] # array of relative directories of svg files.

# Read the SVG image directory and create a list of .svg files.
count = 0
Dir.glob("#{__dir__}/color_svg/**/*.svg") do |svg_file|
  svg_file.sub!("#{__dir__}/color_svg/", '') # get realitive path
  svg_file.sub!(".svg", '') # remove file extension
  svg_filenames.push(svg_file)
  print '.'
  count += 1
  if count >= 70
    count = 0
    print "\n"
  end 
end
print "\n"

# alphabetically sort the svg files by name
svg_filenames.sort!

# Create the qrc file list for qml resource inclusion.
puts "-" * 70
puts "Creating list of (#{svg_filenames.length})...\n"
File.open("svg.qrc", "w") { |f|
  f.write("<qresource prefix=\"crypto-svg\">\n")
  svg_filenames.each do |svg_file|
    
    f.write("\t<file alias=\"#{svg_file}\">crypto-currency-icons/color_svg/#{svg_file}.svg</file>\n")
  end
  f.write("</qresource>\n")
}



# report job finsihed.
puts "=" * 70
puts "qrc resource list is ready."
puts "=" * 70