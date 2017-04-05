# == Class: wkhtmltopdf
#
# Installs the wkhtmltopdf package.
#
class wkhtmltopdf {
  package { 'wkhtmltopdf':
    ensure => 'present',
  }
}
