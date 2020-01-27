# == Class: users
#
# Manages user accounts
#
# === Parameters
#
# [*pentest_machines*]
#   List of machines which pentesters require access to.
#   Default: []
#
# [*pentest_usernames*]
#   List of pentest user accounts to add.
#   Default: []
#
# [*root_password_encrypted*]
#   A string which is in the format that the operating system requires passwords
#   (eg a SHA-512 hash on Ubuntu).
#
# [*usernames*]
#   Users to add to all servers
#   Default: '[]'
#
class users (
  $pentest_machines = [],
  $pentest_usernames = [],
  $licensify_machines = [],
  $licensify_usernames = [],
  $root_password_encrypted,
  $usernames = [],
) {

  validate_array($pentest_machines, $pentest_usernames, $licensify_machines, $licensify_usernames, $usernames)

  user { 'root':
    ensure   => present,
    password => $root_password_encrypted,
    require  => Package['ruby-shadow'],
  }

  # Remove unmanaged UIDs >= 500 (users, not system accounts),
  # In order to have no user accounts defined and purge existing accounts, you *must*
  # have usernames => ['null_user'] set via hiera or otherwise during class instantiation.
  # This is a safety check to prevent accidentally passing a blank list of users and
  # then removing all accounts
  if (!empty($usernames) or !empty($pentest_usernames) or !empty($licensify_usernames)) {
    resources { 'user':
      purge              => true,
      unless_system_user => 500,
    }
  } else {
    notify {'missing usernames':
        message => 'You have not specified any users so no users will be purged.',
    }
  }

  group { 'admin':
    name => 'admin',
    gid  => '3000',
  }

  # Ignore accounts for Vagrant and VirtualBox.
  # Prevents them from being purged.
  user { ['vagrant', 'vboxadd']:
    ensure => undef,
  }

  $usernames_classes = regsubst($usernames, '^', 'users::')

  include $usernames_classes

  if ($::hostname in $pentest_machines) {
    $pentest_user_classes = regsubst($pentest_usernames, '^', 'users::')
    include $pentest_user_classes
  }

  if ($::aws_migration in $licensify_machines) {
    $licensify_user_classes = regsubst($licensify_usernames, '^', 'users::')
    include $licensify_user_classes
  }
}
