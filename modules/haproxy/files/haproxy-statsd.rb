#!/usr/bin/ruby

require 'socket'
HOSTNAME = `facter hostname`.chomp
SOCKET = UDPSocket.new

IO.popen(["curl","-s","http://localhost:8000/haproxy;csv"]) do |haproxy_csv|
  header_line = haproxy_csv.gets
  header_line.gsub!(/# /,'')
  HEADERS = header_line.split(/,/)[0..-2]

  while line = haproxy_csv.gets do
    stats = Hash[HEADERS.zip($_.split(/,/))]
    %w(scur smax ereq econ rate).each do |statname|
      SOCKET.send("haproxy.#{HOSTNAME}.#{stats['pxname']}.#{stats['svname']}.#{statname}:#{stats[statname]}|g",0,'127.0.0.1',8125)
    end
  end
end
