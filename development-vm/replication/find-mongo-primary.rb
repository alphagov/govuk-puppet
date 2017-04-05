#!/usr/bin/env ruby

# Run on a box running Mongo, this script will print the name of the primary
# host in the Mongo cluster to STDOUT. If the box is the current master, return
# a zero exit code with no output.

output = `echo 'db.isMaster().primary' | mongo --quiet | grep -v 'bye'`

if output.empty?
    puts "localhost"
else
    puts output
end
