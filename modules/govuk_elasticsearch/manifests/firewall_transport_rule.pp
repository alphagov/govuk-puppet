# == Define: govuk_elasticsearch::firewall_transport_rule
#
# Create a firewall allow rule for a given host:port.  This looks up the ip for
# the host by finding the corresponding govuk_host instance, and creates a
# corresponding UFW allow rule for the given port (or 9300 if unspecified).
#
define govuk_elasticsearch::firewall_transport_rule {

  $host_port_regex = '^([a-z0-9-]+)(?:\.[a-z0-9-]+)*(?::([0-9]+))?$'

  validate_re($title, $host_port_regex, "'${title}' is not in the form hostname:port")

  $hostname = regsubst($title, $host_port_regex, '\1')
  $hostport = regsubst($title, $host_port_regex, '\2')

  if $hostname != 'localhost' {

    $ip = getparam(Govuk_host[$hostname], 'ip')
    if $ip == '' {
      fail("Could not find govuk_host instance for ${hostname}")
    }

    $port_real = $hostport ? {
      '' => 9300,
      default => $hostport,
    }

    @ufw::allow { "allow-elasticsearch-transport-${port_real}-from-${hostname}":
      port => $port_real,
      from => $ip,
    }
  }
}
