# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class base::packages ($ruby_version=installed){

  ensure_packages([
      'ack-grep',
      'bzip2',
      'dnsutils',
      'dstat',
      'gettext',
      'git',
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
      'mailutils',
      'man-db',
      'manpages',
      'pv',
      'tar',
      'tree',
      'unzip',
      'vim-nox',
      'xz-utils',
      'zip'
    ])

  alternatives { 'editor':
    path    => '/usr/bin/vim.nox',
    require => Package['vim-nox'],
  }

  package { 'libruby1.9.1':
    ensure => $ruby_version,
  }

  package { 'ruby1.9.1-dev':
    ensure  => $ruby_version,
    require => Package['libruby1.9.1', 'ruby1.9.1'],
  }

  package { 'ruby1.9.1':
    ensure  => $ruby_version,
    require => Package['libruby1.9.1'],
  }

  alternatives { 'ruby':
    path    => '/usr/bin/ruby1.9.1',
    require => Package['ruby1.9.1'],
  }

  include nodejs
}
