# == Define: fail2ban::config::jail_snippet
#
# Define a fail2ban jail config snippet. This will create a corresponding file
# in /etc/fail2ban/jail.d
#
# This is intended to be used as a virtual resource. The fail2ban::config class
# will realise these if it's present.
#
# === Parameters
#
# [*order*]
#   The order component of the filename. Used to control the order the snippets
#   are loaded.
#   Default: '01'
#
# [*source*]
# [*content*]
#   The source, or contents of the file snippet.  These are passed through to
#   the underlying file resource.
#
define fail2ban::config::jail_snippet (
  $order = '01',
  $source = undef,
  $content = undef,
) {

  if $::lsbdistcodename == 'precise' {
    warning 'fail2ban::config::jail_snippet not supported on precise'
  } else {

    file { "/etc/fail2ban/jail.d/${order}_${title}.local":
      source  => $source,
      content => $content,
      require => Class['fail2ban::config'],
    }
  }
}
