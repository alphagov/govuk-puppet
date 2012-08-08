class sshd::package {
  package {'openssh-server':
        ensure => present
  }
}
