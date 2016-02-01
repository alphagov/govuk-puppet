# == Class: imagemagick
#
# Installs the imagemagick package.
#
class imagemagick {
  package { 'imagemagick':
    ensure => installed,
  }
}
