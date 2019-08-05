# == Class: chromedriver
#
# Install chromedriver <http://chromedriver.chromium.org/> from the Google mirror.
#
class chromedriver {
  include govuk_ppa

  archive { '/tmp/chromedriver_linux64.zip':
    ensure       => 'present',
    source       => 'https://chromedriver.storage.googleapis.com/76.0.3809.68/chromedriver_linux64.zip',
    extract      => true,
    extract_path => '/usr/local/bin',
    cleanup      => true,
  } ~> file { '/usr/local/bin/chromedriver':
    ensure => 'present',
    mode   => '0755',
  }

  package { 'libnss3-dev':
    ensure  => 'present',
    require => Class['govuk_ppa'],
  }
}
