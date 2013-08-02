#!/usr/bin/env ruby

# gets a list of files and extracts the text using tika
# then saves the output as a text file with the same name unless the file is already a text file
# returns the file names so that we also move them into the 'clean' dir
while filename = gets
  filename = filename.strip
  text_file_name = filename.gsub(/\.[^\.]+$/, ".txt")
  next if filename == text_file_name
  cmd = %Q{tika -t "#{filename}" > "#{text_file_name}"}
  `#{cmd}`
  puts text_file_name
end
