# == Type: govuk_user
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
# [*groups*]
#   An array of group names that the user should belong to
#   Default: ['admin', 'deploy']
#
# [*purgegroups*]
#   Whether to remove the user from non-listed groups
#   Default: false
#
# [*shell*]
#   The user's login shell. Default: "/bin/bash"
#
# [*expiry*]
#   The expiry date for this user. Must be provided in a zero-padded YYYY-MM-DD
#   format - e.g. 2010-02-19. If you want to make sure the user account never
#   expires, you can pass the special value `absent` (this is the default).
#
# [*ssh_key*]
#   The user's SSH public key as a string or array thereof, e.g.
#
#       "ssh-rsa AAAAB3NzaC1yc[...]KKT65FL+uUaC comment"
#
#   Not providing a param, or setting the user as absent, will result in any
#   existing file being removed. The `.ssh` directory will be created for
#   present users regardless of whether `ssh_key` is passed.
#
define govuk_user(
  $ensure = present,
  $fullname = 'No Name',
  $email = 'no.name@digital.cabinet-office.gov.uk',
  $groups = ['admin', 'deploy', 'adm' ],
  $purgegroups = false,
  $shell = '/bin/bash',
  $expiry = absent,
  $ssh_key = undef
) {

  $home = "/home/${title}"

  if ($ensure == present) {
    $dir_ensure = directory

    if ($ssh_key) {
      $key_ensure  = present
      $key_content = template('govuk/home/govuk_user/.ssh/authorized_keys.erb')
    } else {
      # Don't eval template if we're deleting anyway.
      $key_ensure  = absent
      $key_content = undef
    }
  } else {
    $dir_ensure = undef
    $key_ensure = absent
    $key_content = undef
  }

  validate_bool($purgegroups)
  if ($purgegroups) {
    $membership = 'inclusive'
  } else {
    $membership = 'minimum'
  }

  validate_re($expiry, '^(absent|\d{4}-\d{2}-\d{2})$')

  user { $title:
    ensure     => $ensure,
    comment    => "${fullname} <${email}>",
    expiry     => $expiry,
    home       => $home,
    managehome => true,
    groups     => $groups,
    membership => $membership,
    require    => Class['shell'],
    shell      => $shell,
  } ->
  file { $home:
    ensure => directory,
    owner  => $title,
    group  => $title,
    mode   => '0750',
  }

  # FIXME: Manage group?
  file { "${home}/.ssh":
    ensure => $dir_ensure,
    owner  => $title,
    group  => undef,
    mode   => '0700',
  }

  # FIXME: Manage group?
  file { "${home}/.ssh/authorized_keys":
    ensure  => $key_ensure,
    owner   => $title,
    group   => undef,
    mode    => '0600',
    content => $key_content,
  }
}
