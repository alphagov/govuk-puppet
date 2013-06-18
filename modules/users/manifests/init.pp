class users {
  # Remove unmanaged UIDs >= 500 (users, not system accounts).
  # FIXME: Remove noop when we have ruled out false-positives.
  resources { 'user':
    purge              => true,
    unless_system_user => 500,
    noop               => true,
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
}
