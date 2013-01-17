# == Type: govuk::user
#
# Set up a user with default settings for the GOV.UK stack
#
# === Parameters
#
# [*ensure*]
#   The desired state of the user, "present" or "absent".
#
# [*fullname*]
#   The user's full name, e.g. "Joe Bloggs"
#
# [*email*]
#   The user's email address, e.g. "joe.bloggs@digital.cabinet-office.gov.uk"
#
# [*shell*]
#   The user's login shell. Default: "/bin/bash"
#
# [*ssh_key*]
#   The user's SSH public key, e.g. "AAAAB3NzaC1yc[...]KKT65FL+uUaC"
#
# [*ssh_key_type*]
#   The key type of the user's SSH public key: "ssh-rsa", "ssh-dsa", etc.
#
# [*has_deploy*]
#   Whether the user should have SSH access to the 'deploy' user.
#
define govuk::user(
  $ensure = present,
  $fullname = 'No Name',
  $email = 'no.name@digital.cabinet-office.gov.uk',
  $shell = '/bin/bash',
  $ssh_key = undef,
  $ssh_key_type = 'ssh-rsa',
  $has_deploy = false
) {

  user { $title:
    ensure     => $ensure,
    comment    => "${fullname} <${email}>",
    home       => "/home/${title}",
    managehome => true,
    groups     => ['admin', 'deploy'],
    require    => Class['shell'],
    shell      => $shell,
  }

  if $ssh_key != undef {
    ssh_authorized_key { "${title}_key":
      ensure => $ensure,
      key    => $ssh_key,
      type   => $ssh_key_type,
      user   => $title,
    }

    if $has_deploy {
      ssh_authorized_key { "deploy_key_${title}":
        ensure => $ensure,
        key    => $ssh_key,
        type   => $ssh_key_type,
        user   => 'deploy',
      }
    } else {
      ssh_authorized_key { "deploy_key_${title}":
        ensure => absent,
        key    => $ssh_key,
        type   => $ssh_key_type,
        user   => 'deploy',
      }
    }
  }
}
