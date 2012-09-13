class ssh::package {

  package { 'openssh-server':
    ensure => present
  }

}
