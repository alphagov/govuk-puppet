class users::setup {
  include shell
  package { 'zsh':
    ensure => latest,
  }
  group { 'admin':
    name        => 'admin',
    gid         => '3000',
  }
  user { 'deploy':
    ensure      => present,
    home        => '/home/deploy',
    managehome  => true,
    shell       => '/bin/bash'
  }
  file { '/data':
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    mode    => '0755',
    require => User['deploy'],
  }
  ssh_authorized_key {
    'deploy_key_minglis':
      ensure  => present,
      key     => extlookup('minglis_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_heathd':
      ensure  => present,
      key     => extlookup('heathd_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_fberriman':
      ensure  => present,
      key     => extlookup('fberriman_key', ''),
      type    => 'ssh-dss',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_paulb':
      ensure  => present,
      key     => extlookup('paulb_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_garethr':
      ensure  => present,
      key     => extlookup('garethr_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_james':
      ensure  => present,
      key     => extlookup('james_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_mwall':
      ensure  => present,
      key     => extlookup('mwall_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_jordanh':
      ensure  => present,
      key     => extlookup('jordanh_key', ''),
      type    => 'ssh-dss',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_dafydd':
      ensure  => present,
      key     => extlookup('dafydd_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_jenkins':
      ensure  => present,
      key     => extlookup('jenkins_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_annashipman':
      ensure  => present,
      key     => extlookup('annashipman_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_jamesweiner':
      ensure  => present,
      key     => extlookup('jamesweiner_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_davidt':
      ensure  => present,
      key     => extlookup('davidt_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_mazz':
      ensure  => present,
      key     => extlookup('mazz_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_robyoung':
      ensure  => present,
      key     => extlookup('robyoung_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_alext':
      ensure  => present,
      key     => extlookup('alext_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_jabley':
      ensure  => present,
      key     => extlookup('jabley_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    }
}
