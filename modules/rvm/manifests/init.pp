class rvm {

  file {'install-system-rvm':
    ensure => 'present',
    path   => '/root/install-system-rvm',
    owner  => 'root', group => 'root', mode => '0774',
    source => 'puppet:///modules/rvm/install-system-rvm',
  }

  exec { 'system-rvm':
    command => 'sudo /root/install-system-rvm',
    require => [
      File['install-system-rvm'],
      Package['curl', 'git'],
    ],
    creates => '/usr/local/bin/rvm',
  }

  define default_ruby() {
    exec { "install-ruby-$name":
      command => "sudo rvm pkg install zlib && sudo rvm install $name --with-zlib-dir=/usr/local/rvm/usr && sudo rvm use $name --default",
      unless  => "test -f /usr/local/rvm/rubies/default/bin/ruby && ( /usr/local/rvm/rubies/default/bin/ruby -v | grep $name )",
      timeout => 3600,
      require => Exec["system-rvm"],
    }
  }

  define gem() {
    exec { "install-gem-$name":
      command => "sudo rvm gem install $name --no-rdoc --no-ri",
      unless  => "sudo rvm gem list $name | grep $name",
      require => Exec['system-rvm'],
    }
  }
}
