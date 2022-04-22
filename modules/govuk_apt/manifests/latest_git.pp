# == Class: govuk_apt::latest_git
#
# Class to install latest available version of Git. See
# https://launchpad.net/~git-core/+archive/ubuntu/ppa/+index#
#
class govuk_apt::latest_git {
  package { 'git':
    ensure  => latest,
  }
}
