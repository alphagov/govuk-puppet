define nagios::nrpe_config (
  $content = undef,
  $source = undef
) {
  file { "/etc/nagios/nrpe.d/${title}.cfg":
    ensure  => 'file',
    content => $content,
    source  => $source,
    require => Class['nagios::client::package'],
    notify  => Class['nagios::client::service'],
  }
}
