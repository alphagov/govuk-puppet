define icinga::nrpe_config (
  $content = undef,
  $source = undef
) {

  file { "/etc/nagios/nrpe.d/${title}.cfg":
    ensure  => 'file',
    content => $content,
    source  => $source,
    require => Class['icinga::client::package'],
    notify  => Class['icinga::client::service'],
  }

}
