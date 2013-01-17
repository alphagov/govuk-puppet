class base {
  include apt
  include base_packages
  include cron
  include gcc
  include lockrun
  include logrotate
  include ntp
  include screen
  include shell
  include ssh
  include sudo
  include sysctl
  include tmpreaper
  include tmux
  include unattended_upgrades
  include wget
}
