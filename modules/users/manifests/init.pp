# In order to have no user accounts defined, you *must* have user_groups => ['none']
# set via hiera or otherwise during class instantiation. This is a safety check to
# prevent accidentally passing a blank list of users.
class users (
    $user_groups
  ) {
  # Remove unmanaged UIDs >= 500 (users, not system accounts).
  resources { 'user':
    purge              => true,
    unless_system_user => 500,
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

  $user_groups_real = regsubst($user_groups, '^', 'users::groups::')
  class { $user_groups_real: }
}
