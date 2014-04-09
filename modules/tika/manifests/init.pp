# == Class: tika
#
# Install tika and it's dependency `libxtst6`. Typically used for extracting
# text from file attachments.
#
# You will need to include a JRE/JDK and reference them using
# `govuk_java::set_defaults` in your node/app class before including this class.
#
class tika {
  include govuk::repository

  package { 'libxtst6':
    ensure => 'latest'
  }

  package { 'tika':
    ensure  => '1.4-gds1',
    require => [
      Package['libxtst6'],
      Class['govuk_java::set_defaults']
    ]
  }
}
