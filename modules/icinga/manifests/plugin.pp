define icinga::plugin (
  $content = undef,
  $source = undef
) {

  file { "/usr/lib/nagios/plugins/${title}":
    ensure  => 'file',
    mode    => '0755',
    content => $content,
    source  => $source,
    require => Class['icinga::client::package'],
    notify  => Class['icinga::client::service'],
  }

}
