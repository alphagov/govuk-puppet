class ruby::rubygems ($version) {
    $system_path = '/var/lib/gems'
    $rubygems_path = '/usr/lib/ruby/gems'

    exec { "rubygems-${version}" :
      command   => "gem install rubygems-update -v ${version} && update_rubygems _${version}_",
      unless    => "gem -v | grep -q '^${version}$'",
      logoutput => on_failure,
    }

    file { $rubygems_path:
      ensure  => directory,
    }

    exec { 'migrate_system_rubygems':
      command => "/bin/mv ${system_path}/* ${rubygems_path}/",
      onlyif  => "/usr/bin/test -d ${system_path}",
      require => File[$rubygems_path],
    }

    file { $system_path:
      ensure  => absent,
      force   => true,
      backup  => false,
      require => Exec['migrate_system_rubygems'],
    }

    package { 'rubygems':
      ensure  => absent,
      require => File[$system_path],
    }
}
