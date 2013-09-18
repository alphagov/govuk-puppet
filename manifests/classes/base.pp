class base {
  include apparmor
  include base_packages
  include cron
  include gcc
  include logrotate
  include ntp
  include screen
  include shell
  include ssh
  include motd
  include sudo
  include sysctl
  include tmpreaper
  include tmux
  include wget
  include curl

  class { 'apt':
    always_apt_update    => true,
    purge_sources_list_d => true,
  }
  class { 'apt::unattended_upgrades':
    mail_to => 'machine.email@digital.cabinet-office.gov.uk',
    origins => [
      "${::lsbdistid} stable",
      "${::lsbdistid} ${::lsbdistcodename}-security",
    ],
  }

}
