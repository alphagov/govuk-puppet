class shell {
  file { '/etc/skel/.bashrc':
    ensure  => 'present',
    source  => 'puppet:///modules/shell/bashrc'
  }
}
