# == Class: Govuk_containers::Frontend::Haproxy
#
# Manage Haproxy frontend for container boxes
#
# === Parameters:
#
# [*backend_mappings*]
#   Array of hashes with domain to backend mapping information to configure Haproxy
#   frontend. The backend needs to match the name of the relevant haproxy::backend
#   resource in govuk_containers::balancermember:
#
#   [ { "release.dev.gov.uk" => "release" } ]
#
class govuk_containers::frontend::haproxy (
  $backend_mappings,
) {

  # Override global default options in the upstream module
  class { '::haproxy':
    global_options   => {
      'log'     => "${::ipaddress_lo} local0",
      'chroot'  => '/var/lib/haproxy',
      'pidfile' => '/var/run/haproxy.pid',
      'maxconn' => '4000',
      'user'    => 'haproxy',
      'group'   => 'haproxy',
      'daemon'  => '',
      'stats'   => 'socket /var/lib/haproxy/stats mode 600 level admin',
    },
  }

  apt::pin { 'haproxy':
    packages => 'haproxy',
    release  => 'trusty-backports',
    priority => 1001, # 1001 will cause a downgrade if necessary
  }

  rsyslog::snippet { 'haproxy':
    content => "\$ModLoad imudp\n\$UDPServerRun 514\n\$UDPServerAddress 127.0.0.1\nlocal0.* /var/log/haproxy.log",
  }

  haproxy::frontend { $::hostname:
    mode    => 'http',
    options => {
      'timeout client' => '30s',
      'option'         => [
        'httplog',
        'accept-invalid-http-request',
      ],
      'use_backend'    => '%[req.hdr(host),lower,map(/etc/haproxy/domains-to-backends.map,bk_default)]',
    },
  }

  @@icinga::check { "check_haproxy_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running_with_arg!haproxy /etc/haproxy/haproxy.cfg',
    service_description => 'HAProxy running',
    host_name           => $::fqdn,
  }

  class { 'collectd::plugin::haproxy': }

  haproxy::mapfile { 'domains-to-backends':
    ensure   => 'present',
    mappings => $backend_mappings,
  }

}
