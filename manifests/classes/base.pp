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

  # Ensure update is always run before any package installs.
  # title conditions prevent a dependency loop within apt module.
  Class['apt::update'] -> Package <|
    provider != pip and
    provider != gem and
    ensure != absent and
    ensure != purged and
    title != 'python-software-properties' and
    title != 'software-properties-common' and
    tag != 'no_require_apt_update'
  |>

}
