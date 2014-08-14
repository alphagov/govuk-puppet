# == Define: statsd::counter
#
# Ensures a statsd counter exists
#
define statsd::counter() {
  exec {"statsd counter ${title}":
    command => "/bin/bash -c '/bin/echo -n \"${title}:0|c\" > /dev/udp/localhost/8125'",
    unless  => "/bin/echo counters | /bin/nc localhost 8126 | /bin/grep -qF '${title}'",
    onlyif  => '/bin/nc -z localhost 8126', # ie only if statsd is actually running
  }
}
