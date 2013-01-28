class ssh::firewall {
  ufw::allow { "allow-ssh-from-all":
    port => 22,
  }
}
