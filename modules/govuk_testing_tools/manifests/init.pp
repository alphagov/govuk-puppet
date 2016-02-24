# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_testing_tools {
  include phantomjs

  package { [
    'qt4-qmake',     # needed for capybara-webkit
    'qt4-dev-tools', #    "            "
    'xvfb',
    ]:
    ensure => installed;
  }

  file { '/etc/init/xvfb.conf':
    ensure => present,
    source => 'puppet:///modules/govuk_testing_tools/xvfb.conf',
  }

  service { 'xvfb':
    ensure   => running,
    provider => upstart,
    require  => [
      Package['xvfb'],
      File['/etc/init/xvfb.conf'],
    ],
  }

}
