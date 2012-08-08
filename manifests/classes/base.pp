class base {
  include apt
  include base_packages
  include cron
  include logrotate
  include motd
  include ntp
  include sudo
  include sysctl
  include sshd
  include unattended_upgrades
}
