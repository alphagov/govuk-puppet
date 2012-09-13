class base {
  include apt
  include base_packages
  include cron
  include logrotate
  include ntp
  include sudo
  include sysctl
  include sshd
  include tmpreaper
  include unattended_upgrades
  include wget
}
