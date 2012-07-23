class govuk::deploy_tools {
  include bundler
  include fpm
  include python
  include pip
  include govuk::spinup
}
