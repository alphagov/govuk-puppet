# == Class: govuk::node::s_training
#
# GOV.UK training VM.
#
# === Parameters
#
class govuk::node::s_training {
  include govuk::node::s_development

  postgresql::server::role {
    'ubuntu':
      password_hash => postgresql_password('vagrant', 'vagrant'),
      createdb      => true;
  }

}
