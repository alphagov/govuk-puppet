# Class govuk_ci::agent::nodejs
#
# Installs nodejs and nodejs specific tools
#
class govuk_ci::agent::nodejs {

  # uglifier requires a JavaScript runtime
  # alphagov/spotlight requires a decent version of Node (0.10+) and grunt-cli

  package { 'grunt-cli':
    ensure   => '0.1.9',
    provider => 'npm',
    require  => Class['::nodejs'],
  }
}
