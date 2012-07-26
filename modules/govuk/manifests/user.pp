define govuk::user(
  $fullname = 'No Name',
  $email = 'no.name@digital.cabinet-office.gov.uk',
  $ensure = present,
  $shell = '/bin/bash',
  $ssh_key = 'NOTSET',
  $ssh_key_type = 'ssh-rsa',
  $has_deploy = true
) {

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
    require    => [Group['admin'], Group['deploy']],
    shell      => $shell;
  }
  ssh_authorized_key { $ssh_key_name:
    ensure  => $ensure,
    key     => extlookup($ssh_key_name, ''),
    type    => $ssh_key_type,
    user    => $title,
    require => User[$title];
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
