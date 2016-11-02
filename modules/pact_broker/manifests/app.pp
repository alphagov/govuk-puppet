# == Class: pact_broker::app
#
# Install the pact-broker 'application'
#
class pact_broker::app (
  $app_root,
  $user,
) {
  $ruby_version = '2.2.3'

  include ::postgresql::lib::devel

  File {
    owner => $user,
    group => $user,
    mode  => '0644',
  }

  file { $app_root:
    ensure => directory,
    mode   => '0755',
  }

  file { "${app_root}/.ruby-version":
    content => "${ruby_version}\n",
  }

  file { "${app_root}/Gemfile":
    source => 'puppet:///modules/pact_broker/Gemfile',
  }
  file { "${app_root}/Gemfile.lock":
    source => 'puppet:///modules/pact_broker/Gemfile.lock',
  }

  # TODO move this to the normal application release process
  # bash -l used to pick up environment (including rbenv setup)
  exec { 'bash -l -c "bundle install --deployment --path vendor/bundle"':
    cwd         => $app_root,
    user        => $user,
    path        => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
    environment => 'TMP=/tmp',
    refreshonly => true,
    require     => Rbenv::Version[$ruby_version],
    subscribe   => File["${app_root}/Gemfile.lock"],
  }

  file { "${app_root}/config.ru":
    source => 'puppet:///modules/pact_broker/config.ru',
  }
}
