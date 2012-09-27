class fonts {
  $fontdir = '/usr/share/fonts/gov_uk'

  package {'ttmkfdir': ensure => present }

  file { $fontdir:
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0644',
    recurse => true,
    source  => 'puppet:///modules/fonts/usr/share/fonts/gov_uk',
    notify  => [Exec['make_font_metadata']]
  }

  exec {'make_font_metadata':
    cwd         => $fontdir,
    command     => '/usr/bin/ttmkfdir .',
    refreshonly => true
  }
}