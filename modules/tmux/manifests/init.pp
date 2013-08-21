# == Class: tmux
#
# Install and configure the tmux terminal multiplexer, a replacement for GNU
# screen.
#
class tmux {
  package { 'tmux':
    ensure => present,
  }
}
