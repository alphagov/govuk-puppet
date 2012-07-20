class govuk::deploy_tools {
  include bundler
  include fpm
  include pip
  include govuk::spinup
}
