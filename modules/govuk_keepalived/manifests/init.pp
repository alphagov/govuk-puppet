# == govuk_keepalived
#
# Configure keepalived for floating IP addresses.
#
# === Parameters
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
  $instances,
  $interface = 'eth0',
) {
  include keepalived

  $track_script = 'check_nginx'

  keepalived::vrrp::script { $track_script:
    script => 'curl --max-time 1 -H "Host: monitoring-vhost.test" localhost 2>/dev/null | grep -q "nginx is ok"',
  }

  $defaults = {
    'advert_int'   => 5,
    'auth_type'    => 'PASS',
    'interface'    => $interface,
    'nopreempt'    => true,
    'priority'     => fqdn_rand(254) + 1, # Priorities 0 and 255 have special meaning
    'state'        => 'BACKUP',
    'track_script' => $track_script,
  }

  create_resources(keepalived::vrrp::instance, $instances, $defaults)
}
