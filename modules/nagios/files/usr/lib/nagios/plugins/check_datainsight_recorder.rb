#! /usr/bin/env ruby

require "date"
require "net/http"
require "json"

CACHE_TIME_IN_MINUTES = 15
ADDITIONAL_TOLERANCE_IN_MINUTES = 5


def print_status(status, diff_in_minutes, last_update_date)
  puts "#{status}: service last updated at #{last_update_date} (#{diff_in_minutes.to_i} minutes ago)"
end

def compute_threshold(expected_refresh_interval_in_minutes)
  expected_refresh_interval_in_minutes + CACHE_TIME_IN_MINUTES + ADDITIONAL_TOLERANCE_IN_MINUTES
end

if ARGV.length < 2
  puts "Usage: #{__FILE__} <URI> <THRESHOLD_IN_MINUTES>"
  exit(3)
end

begin

  uri=URI.parse(ARGV[0])
  THRESHOLD_IN_MINUTES = compute_threshold(Integer(ARGV[1]))

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = (uri.scheme == 'https')

  response = http.request(Net::HTTP::Get.new(uri.path))
  raise "Service returned HTTP #{response.code}" unless response.is_a? Net::HTTPOK

  result = JSON.parse(response.body)
  last_update_date = result["updated_at"]
  delta = DateTime.now - DateTime.parse(last_update_date)
  diff_in_minutes = delta * 24 * 60

rescue Exception => e
  puts "ERROR: #{e} \n\t#{e.backtrace.join("\n\t")}"
  exit(2)
end

if diff_in_minutes > THRESHOLD_IN_MINUTES
  print_status("ERROR", diff_in_minutes, last_update_date)
  exit(2)
end

print_status("OK", diff_in_minutes, last_update_date)