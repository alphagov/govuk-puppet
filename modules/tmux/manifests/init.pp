# == Class: tmux
#
# Install and configure the tmux terminal multiplexer, a replacement for GNU
# screen.
#
class tmux {

  package { 'tmux':
    ensure => present,
  }

  file { '/etc/tmux.conf':
    ensure => present,
    source => 'puppet:///modules/tmux/tmux.conf',
  }

}
