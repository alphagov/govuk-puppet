# == Class: imagemagick
#
# Installs the imagemagick package.
#
class imagemagick {
  package { 'imagemagick':
    ensure => '8:6.7.7.10-6ubuntu3.2',
  }

  file { '/etc/ImageMagick/policy.xml':
    ensure  => 'present',
    source  => 'puppet:///modules/imagemagick/etc/ImageMagick/policy.xml',
    require => Package['imagemagick'],
  }
}
