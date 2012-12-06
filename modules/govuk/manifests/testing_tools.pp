class govuk::testing_tools {
  include govuk::phantomjs

  package { [
    'qt4-qmake',     # needed for capybara-webkit
    'qt4-dev-tools', #    "            "
    'xvfb'
    ]:
    ensure => installed;
  }

  file { '/etc/init/xvfb.conf':
    ensure  => present,
    source  => 'puppet:///modules/govuk/xvfb.conf',
  }

  service { 'xvfb':
    ensure   => running,
    provider => upstart,
    require  => [
      Package['xvfb'],
      File['/etc/init/xvfb.conf'],
    ]
  }

  # This is required for the redirector-integration job
  package { 'libcrypt-ssleay-perl':
    ensure => installed,
  }
}
