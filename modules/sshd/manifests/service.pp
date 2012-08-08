class sshd::service {
  service {'sshd':
        ensure      => running,
        name        => 'ssh',
        enable      => true,
        hasstatus   => true,
        hasrestart  => true,
  }
}
