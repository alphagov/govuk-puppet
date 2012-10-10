define govuk::user(
  $fullname = 'No Name',
  $email = 'no.name@digital.cabinet-office.gov.uk',
  $ensure = present,
  $shell = '/bin/bash',
  $ssh_key = 'NOTSET',
  $ssh_key_type = 'ssh-rsa',
  $has_deploy = false
) {

  include shell

  if $ssh_key == 'NOTSET' {
    $ssh_key_name = "${title}_key"
  } else {
    $ssh_key_name = $ssh_key
  }

  user { $title:
    ensure     => $ensure,
    comment    => "$fullname <${email}>",
    home       => "/home/$title",
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => [Class['shell'], Group['admin'], Group['deploy']],
    shell      => $shell,
  }

  file { "/home/$title/.bashrc":
    ensure => $ensure,
    source => 'puppet:///modules/users/bashrc'
    require => User["$title"]
    }
  ssh_authorized_key { $ssh_key_name:
    ensure  => $ensure,
    key     => extlookup($ssh_key_name, ''),
    type    => $ssh_key_type,
    user    => $title,
    require => User[$title],
  }

  if $has_deploy {
    ssh_authorized_key { "deploy_key_${title}":
      ensure  => $ensure,
      key     => extlookup($ssh_key_name, ''),
      type    => $ssh_key_type,
      user    => 'deploy',
      require => User['deploy'];
    }
  } else {
    ssh_authorized_key { "deploy_key_${title}":
      ensure  => absent,
      key     => extlookup($ssh_key_name, ''),
      type    => $ssh_key_type,
      user    => 'deploy',
      require => User['deploy'];
    }
  }
}
