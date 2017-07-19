#
# == Class: guix - installs the GNU Guix daemon and package manager
#
# === Parameters:
#
# [*version*]
# String, default '0.12.0'. Specify the version of Guix to install.
#
# [*base_url*]
# String, default ''ftp://alpha.gnu.org/gnu/guix'. Set the base URL to use
# for download URL.
#
# [*key_id*]
# String, default ''3CE464558A84FDC69DB40CFB090B11993D9AEBB5''. Key to
# fetch, in preparation for the verification of the downloaded
# tarball.
#
# [*install_cwd*]
# String, default '/tmp'. Directory where you would like to download and
# extract the Guix binary installation.
#
# [*download_file*]
# String, default 'guix-binary.tar.xz'. Filename of the downloaded
# file regardless of version.
#
# [*extract_dir*]
# String, default 'guix-binary-unpack'. Subdirectory under
# *install_cwd* that the tarball will be extracted under.
#
# === Requires:
#
# None.
#
# === Examples
#
#    guix {
#      version  => '0.13.0',
#    }
#
class guix (
  $version        = '0.13.0',
  $base_url       = 'https://alpha.gnu.org/gnu/guix/',
  $key_id         = '3CE464558A84FDC69DB40CFB090B11993D9AEBB5',
  $install_cwd    = '/tmp',
  $download_file  = 'guix-binary.tar.xz',
  $extract_dir    = 'guix-binary-unpack',
) {

  $system = $::osfamily ? {
    default   => 'x86_64-linux',
  }
  $url="${base_url}/guix-binary-${version}.${system}.tar.xz"

  $unpacked_tarball_path = "${install_cwd}/${extract_dir}"

  exec { "curl -sL -o ${install_cwd}/${download_file} ${url}":
    alias   => 'download-guix',
    cwd     => $install_cwd,
    creates => "${install_cwd}/${download_file}",
    unless  => 'test -d /gnu/store',
  }

  exec { "curl -sL -o ${install_cwd}/${download_file}.sig ${url}.sig":
    alias   => 'download-guix-signature',
    cwd     => $install_cwd,
    creates => "${install_cwd}/${download_file}.sig",
    unless  => 'test -d /gnu/store',
  }

  exec { "gpg --keyserver pool.sks-keyservers.net --recv-keys ${key_id}":
    alias  => 'fetch-public-key',
    unless => "gpg -k ${key_id}",
  }

  exec { 'guix archive --authorize < /var/guix/profiles/per-user/root/guix-profile/share/guix/hydra.gnu.org.pub':
    alias     => 'authorize-gnu-hydra',
    require   => [
      Exec['create /var/guix'],
      File['/usr/local/bin/guix'],
    ],
    user      => root,
    creates   => '/etc/guix/acl',
  }

  exec { "mkdir -p ${unpacked_tarball_path} && tar xf ${install_cwd}/${download_file} -C ${unpacked_tarball_path}":
    alias   => 'extract-guix-tarball',
    require => [
      Exec['download-guix'],
      Exec['download-guix-signature'],
      Exec['fetch-public-key'],
    ],
    onlyif  => "gpg --verify ${download_file}.sig",
    cwd     => $install_cwd,
    creates => [
      "${unpacked_tarball_path}/gnu",
      "${unpacked_tarball_path}/var/guix",
    ],
    unless  => 'test -d /gnu',
  }

  exec { 'mv var/guix /var/':
    alias   => 'create /var/guix',
    require => Exec['extract-guix-tarball'],
    cwd     => $unpacked_tarball_path,
    creates => '/var/guix/',
  }

  exec { 'mv gnu /':
    alias   => 'create /gnu/',
    require => Exec['extract-guix-tarball'],
    cwd     => $unpacked_tarball_path,
    creates => '/gnu',
  }

  file { '/root/.guix-profile':
    ensure  => 'link',
    require => Exec['create /var/guix'],
    target  => '/var/guix/profiles/per-user/root/guix-profile',
  }

  file { '/usr/local/bin/guix':
    ensure  => 'link',
    require => Exec['create /var/guix'],
    target  => '/var/guix/profiles/per-user/root/guix-profile/bin/guix',
  }

  group { 'guixbuild':
    ensure => 'present',
    system => 'yes',
  }

  $build_usernames = [
      'guixbuilder01',
      'guixbuilder02',
      'guixbuilder03',
      'guixbuilder04',
      'guixbuilder05',
      'guixbuilder06',
      'guixbuilder07',
      'guixbuilder08',
      'guixbuilder09',
      'guixbuilder10',
  ]

  user { $build_usernames:
    ensure  => 'present',
    gid     => 'guixbuild',
    groups  => ['guixbuild'],
    home    => '/var/empty',
    shell   => '/usr/sbin/nologin',
    comment => 'Guix build user',
    system  => 'yes',
  }

  file { '/etc/init/guix-daemon.conf':
    ensure  => file,
    owner   => root,
    source  => 'puppet:///modules/guix/etc/init/guix-daemon.conf',
    require => [
      Exec['create /var/guix'],
    ],
  }

  service { 'guix-daemon':
    ensure   => running,
    provider => 'upstart',
    require  => [
      File['/etc/init/guix-daemon.conf'],
    ],
  }
}
