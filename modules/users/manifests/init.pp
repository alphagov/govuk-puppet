class users {
  group { 'admin':
    name => 'admin',
    gid  => '3000',
  }
}
