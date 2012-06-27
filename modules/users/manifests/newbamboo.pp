class users::newbamboo {
  include users::setup
  user { 'benp':
    ensure     => present,
    comment    => 'Ben Pickles (ben@new-bamboo.co.uk)',
    home       => '/home/benp',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'benp_key':
    ensure  => present,
    key     => extlookup('benp_key', ''),
    type    => 'ssh-rsa',
    user    => 'benp',
    require => User['benp']
  }

  user { 'niallm':
    ensure     => present,
    comment    => 'Niall Mullally <naill@new-bamboo.co.uk>',
    home       => '/home/niallm',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'niallm_key':
    ensure  => present,
    key     => extlookup('niallm_key', ''),
    type    => 'ssh-rsa',
    user    => 'niallm',
    require => User['niallm'],
  }

  user { 'ollyl':
    ensure     => present,
    comment    => 'Olly Legg <olly@new-bamboo.co.uk>',
    home       => '/home/ollyl',
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['users::setup'],
    shell      => '/bin/bash'
  }
  ssh_authorized_key { 'ollyl_key':
    ensure  => present,
    key     => extlookup('ollyl_key', ''),
    type    => 'ssh-rsa',
    user    => 'ollyl',
    require => User['ollyl'],
  }
  ssh_authorized_key {
    'deploy_key_benp':
      ensure  => present,
      key     => extlookup('benp_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_niallm':
      ensure  => present,
      key     => extlookup('niallm_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_ollyl':
      ensure  => present,
      key     => extlookup('ollyl_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
  }
}
