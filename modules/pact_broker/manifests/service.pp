# == Class: pact_broker::service
#
# Configure the pact-broker service
#
class pact_broker::service (
  $deploy_dir,
  $user,
  $port,
  $db_user = 'pact_broker',
  $db_password,
  $db_name = 'pact_broker',
  $auth_user,
  $auth_password,
) {

  file { "${deploy_dir}/unicorn.rb":
    owner   => $user,
    group   => $user,
    mode    => '0644',
    content => template('pact_broker/unicorn.rb.erb'),
    notify  => Service['pact-broker'],
  }

  file { '/etc/init/pact-broker.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0640', # Contains creds so can't be world-readable
    content => template('pact_broker/upstart.conf.erb'),
    notify  => Service['pact-broker'],
  }

  file { [
    '/var/log/pact_broker.log',
    '/var/log/pact_broker.err.log',
  ]:
    ensure => present,
    owner  => $user,
    group  => $user,
    mode   => '0644',
    before => Service['pact-broker'],
  }

  service { 'pact-broker':
    ensure => running,
    enable => true,
  }
}
