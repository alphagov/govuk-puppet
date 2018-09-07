# == Class: nscd::config
#
# === Parameters:
#
class nscd::config (
  $dns_cache = 'no',
) {

  file { '/etc/nscd.conf':
    ensure  => file,
    content => template('nscd/nscd_config.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}
