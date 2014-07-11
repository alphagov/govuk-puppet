class ruby::rubygems {

    package { 'rubygems':
      ensure => absent,
    }

    package { 'rubygems-update':
      ensure   => absent,
      provider => 'system_gem',
    }
}
