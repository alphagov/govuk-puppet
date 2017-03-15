# == Class: imagemagick
#
# Installs the imagemagick package.
#
class imagemagick {
  package { 'imagemagick':
    ensure => 'present',
  }

  file { '/etc/ImageMagick/policy.xml':
    ensure  => 'present',
    source  => 'puppet:///modules/imagemagick/etc/ImageMagick/policy.xml',
    require => Package['imagemagick'],
  }
}
