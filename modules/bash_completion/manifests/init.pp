# Class: bash_completion
#
# Installs additional bash completions for the dev vm.
#
class bash_completion {

  package { 'bash-completion':
    ensure  => present,
  }

  file { '/etc/bash_completion.d/git-completion.bash':
    ensure => present,
    source => 'puppet:///modules/bash_completion/etc/bash_completion.d/git-completion.bash',
  }
}
