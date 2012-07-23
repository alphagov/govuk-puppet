class govuk::spinup {
  include envmgr

  file { '/usr/local/bin/govuk_spinup':
    ensure  => present,
    source  => 'puppet:///modules/govuk/govuk_spinup',
    mode    => '0755',
    require => Package['envmgr'];
  }
}
