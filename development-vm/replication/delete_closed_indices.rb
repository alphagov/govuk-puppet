#! /usr/bin/env ruby

require 'net/http'
require 'json'
require 'uri'

list_uri = URI.parse('http://localhost:9200/_cluster/state/blocks')

Net::HTTP.start(list_uri.host, list_uri.port) do |http|
  resp = http.get(list_uri.path)
  data = JSON.parse(resp.body)
  exit 0 if data["blocks"].empty?
  data["blocks"]["indices"].each do |name, index|
    puts name
    http.delete("/#{name}")
  end
end
