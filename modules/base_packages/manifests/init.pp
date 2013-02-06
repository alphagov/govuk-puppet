class base_packages {

  package {
    [
      'ack-grep',
      'bzip2',
      'curl',
      'gettext',
      'git-core',
      'htop',
      'iotop',
      'iptraf',
      'less',
      'libc6-dev',
      'libcurl4-openssl-dev',
      'libreadline-dev',
      'libreadline5',
      'libsqlite3-dev',
      'libxml2-dev',
      'libxslt1-dev',
      'logtail',
      'pv',
      'tar',
      'tree',
      'unzip',
      'vim-nox',
      'xz-utils',
      'zip'
    ]:
    ensure => installed
  }

  # This package creates a dynamic motd generated on ssh login
  package { 'update-motd': ensure => installed}

  # Removing the default files created by update-motd
  file { '/etc/update-motd.d/':
    ensure  => directory,
    # Clear all scripts from this dir that are not puppet managed
    purge   => true,
    recurse => true,
    require => Package['update-motd'],
  }

  case $::lsbdistcodename {
    'precise': {
        package{
          [
            'ruby1.9.1-dev',
          ]:
            ensure => installed,
        }
        include nodejs
    }
    default: {
      # see pivotaltracker 42952267
      package {'dpkg':
        ensure => '1.15.5.6ubuntu4.6',
      }
    }
  }

}
