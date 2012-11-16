class base {
  include apt
  include base_packages
  include cron
  include lockrun
  include logrotate
  include ntp
  include sudo
  include sysctl
  include ssh
  include tmpreaper
  include unattended_upgrades
  include wget
}
