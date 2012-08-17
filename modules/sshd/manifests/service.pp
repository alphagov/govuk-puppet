class sshd::service {
  service {'sshd':
        ensure      => running,
        name        => 'ssh',
        hasstatus   => true,
        hasrestart  => true,
  }
}
