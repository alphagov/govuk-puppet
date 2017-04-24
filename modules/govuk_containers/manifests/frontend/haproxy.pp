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
# [*wildcard_publishing_certificate*]
#   Wildcard publishing certificate
#
# [*wildcard_publishing_key*]
#   Wildcard publishing key
#
class govuk_containers::frontend::haproxy (
  $backend_mappings,
  $wildcard_publishing_certificate,
  $wildcard_publishing_key,
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

  file { [ '/etc/haproxy/ssl' ]:
    ensure  => 'directory',
    require => File['/etc/haproxy'],
  }

  file { '/etc/haproxy/ssl/publishing.pem':
    ensure  => 'present',
    owner   => haproxy,
    mode    => '0640',
    content => inline_template("${wildcard_publishing_certificate}${wildcard_publishing_key}"),
    require => File['/etc/haproxy/ssl'],
  }

  rsyslog::snippet { 'haproxy':
    content => "\$ModLoad imudp\n\$UDPServerRun 514\n\$UDPServerAddress 127.0.0.1\nlocal0.* /var/log/haproxy.log",
  }

  haproxy::frontend { $::hostname:
    mode    => 'http',
    bind    => {
      "${::ipaddress_eth0}:443" => ['ssl', 'crt', '/etc/haproxy/ssl/publishing.pem'],
    },
    options => {
      'timeout client' => '30s',
      'option'         => [
        'httplog',
        'accept-invalid-http-request',
      ],
      'use_backend'    => '%[req.hdr(host),lower,map(/etc/haproxy/domains-to-backends.map,bk_default)]',
    },
  }

  haproxy::mapfile { 'domains-to-backends':
    ensure   => 'present',
    mappings => $backend_mappings,
  }

  @ufw::allow { 'allow-https-from-all':
    port => 443,
  }

}
