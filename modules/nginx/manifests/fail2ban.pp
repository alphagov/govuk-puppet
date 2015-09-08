# == Class: nginx::fail2ban
#
# This class adds nginx specific configuration to
# fail2ban
#
class nginx::fail2ban {
  file { '/etc/fail2ban/jail.d/01_nginx.local':
    source  => 'puppet:///modules/nginx/etc/fail2ban/jail.d/01_nginx.local',
  }
}

