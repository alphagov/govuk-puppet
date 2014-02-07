# == Class: ssh::config
#
# === Parameters:
#
# [*allow_users*]
# Array of users to allow SSH access from.
# Default: [*]
#
# [*allow_users_enable*]
# Whether to enforce the contents of `allow_users`.
# Default: false
#
# [*allow_x11_forwarding*]
# Enable `X11Forwarding` and `X11DisplayOffset` for development.
# Default: false
#
class ssh::config (
  $allow_users = ['*'],
  $allow_users_enable = false,
  $allow_x11_forwarding = false
) {
  validate_array($allow_users)
  validate_bool($allow_users_enable, $allow_x11_forwarding)

  file { '/etc/ssh/sshd_config':
    content => template('ssh/sshd_config.erb'),
    mode    => '0400',
  }

  # This is being created with 0600 permisisons in some cases, which renders is
  # much less useful.  Force it to be world readable.
  file { '/etc/ssh/ssh_known_hosts':
    ensure => file,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }

}
