# == Class: ssh::firewall
#
# Configure the firewall for SSH connections.
#
class ssh::firewall {
  @ufw::allow { 'allow-ssh-from-all':
    port => 22,
  }
}
