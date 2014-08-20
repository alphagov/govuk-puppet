# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class users (
    $user_groups = [],
  ) {
  # Remove unmanaged UIDs >= 500 (users, not system accounts),
  # In order to have no user accounts defined and purge existing accounts, you *must*
  # have user_groups => ['none'] set via hiera or otherwise during class instantiation.
  # This is a safety check to prevent accidentally passing a blank list of users and
  # then removing all accounts
  if !empty($user_groups) {
    resources { 'user':
      purge              => true,
      unless_system_user => 500,
    }
  } else {
    notify {'missing user::groups':
        message => 'You have not set user::groups so users will not be purged',
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

  $user_groups_real = regsubst($user_groups, '^', 'users::groups::')
  class { $user_groups_real: }
}
