# Creates the pp_deploy preview user
# FIXME remove this when user is removed
class users::ppdeploy {
  govuk::user { 'ppdeploy':
    ensure   => absent,
    fullname => 'ppdeploy',
    email    => 'ppdeploy@digital.cabinet-office.gov.uk',
  }
}
