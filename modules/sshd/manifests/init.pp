class sshd {
  include sshd::package
  include sshd::config
  include sshd::service
  Class['sshd::package'] -> Class['sshd::config'] ~> Class['sshd::service']
}
