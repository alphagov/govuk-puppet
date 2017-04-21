# == Define: Govuk_containers::Balancermember
#
# A defined type which creates a Haproxy backend with a balancermember
# for the container application
#
# === Parameters:
#
# [*port*]
#   Container listening port.
#
# [*ipaddress*]
#   Container listening ipaddress
#
# [*options*]
#   Haproxy backend server options
#   Default: 'check'
#
define govuk_containers::balancermember (
  $port,
  $ipaddress = $::ipaddress_lo,
  $options = 'check',
) {

  haproxy::backend { $name:
    mode    => 'http',
    options => {
      'option'  => [
        'httplog',
      ],
      'balance' => 'roundrobin',
    },
  }

  haproxy::balancermember { $name:
    listening_service => $name,
    server_names      => $name,
    ipaddresses       => $ipaddress,
    ports             => $port,
    options           => $options,
  }

}
