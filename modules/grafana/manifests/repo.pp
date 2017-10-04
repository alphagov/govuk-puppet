# == Class: grafana::repo
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
class grafana::repo {
  # FIXME: remove after deployed to Production
  apt::source { 'grafana':
    ensure => 'absent',
  }
}
