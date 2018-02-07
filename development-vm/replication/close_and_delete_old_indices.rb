#! /usr/bin/env ruby

require 'net/http'
require 'json'
require 'uri'

valid_indices = ARGV[0].split(',')

list_uri = URI.parse('http://localhost:9200/_alias')

Net::HTTP.start(list_uri.host, list_uri.port) do |http|
  resp = http.get(list_uri.path)
  data = JSON.parse(resp.body)

  used_aliases = valid_indices.flat_map { |index_name| data[index_name]['aliases'].keys }
  data.each do |index_name, aliases|
    next if valid_indices.include?(index_name)
    if (aliases['aliases'].keys & used_aliases).any?
      puts "Deleting #{index_name}"
      http.delete("/#{index_name}")
    end
  end
end
