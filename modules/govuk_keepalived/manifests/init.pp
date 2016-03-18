# == govuk_keepalived
#
# Configure keepalived for floating IP addresses.
#
# === Parameters
#
# [*auth_pass*]
#   Password used by VRRP protocol for authentication.
#
# [*instances*]
#   Hash of `keepalived::vrrp::instance` resources.
#   Default: {}
#
# [*interface*]
#   Interface to bind to.
#   Default: eth0
#
class govuk_keepalived (
  $auth_pass,
  $instances,
  $interface = 'eth0',
) {
  validate_hash($instances)

  # FIXME: Replace 9999 with empty string once
  # the stdlib supports an infinite upper bound:
  # https://github.com/puppetlabs/puppetlabs-stdlib/blob/b6383d259cf4917edd832ba31cf4dae2b4201235/spec/functions/validate_slength_spec.rb#L57-L60
  validate_slength($auth_pass, 9999, 12)

  include keepalived

  $track_script = 'check_nginx'
  $min_num_procs = 3

  keepalived::vrrp::script { $track_script:
    script => 'curl --max-time 1 -H \'Host: monitoring-vhost.test\' localhost 2>/dev/null | grep -q \'nginx is ok\'',
  }

  $defaults = {
    'auth_pass'    => $auth_pass,
    'advert_int'   => 5,
    'auth_type'    => 'PASS',
    'interface'    => $interface,
    'nopreempt'    => true,
    'priority'     => fqdn_rand(254) + 1, # Priorities 0 and 255 have special meaning
    'state'        => 'BACKUP',
    'track_script' => $track_script,
  }

  create_resources(keepalived::vrrp::instance, $instances, $defaults)

  @@icinga::check { "check_keepalived_running_${::hostname}":
    check_command       => "check_nrpe!check_proc_number!keepalived ${min_num_procs}",
    service_description => "keepalived has ${min_num_procs} or more processes",
    host_name           => $::fqdn,
  }

  ufw::allow { 'Allow VRRP multicast advertisements':
    ip    => '224.0.0.18',
    proto => 'any',
  }
}
