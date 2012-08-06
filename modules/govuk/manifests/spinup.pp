class govuk::spinup {
  include envmgr
  include unicornherder

  file { '/etc/govuk/unicorn.rb':
    ensure => present,
    source => 'puppet:///modules/govuk/etc/govuk/unicorn.rb',
    require => File['/etc/govuk'],
  }

  file { '/usr/local/bin/govuk_spinup':
    ensure  => present,
    source  => 'puppet:///modules/govuk/bin/govuk_spinup',
    mode    => '0755',
    require => Package['envmgr'],
  }

}
