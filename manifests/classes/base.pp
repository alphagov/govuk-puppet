class base {
  include apparmor
  include apt
  include apt::unattended_upgrades
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
