# Creates the bradleyw user
class users::bradleyw {
  govuk::user { 'bradleyw':
    fullname => 'Bradley Wright',
    email    => 'bradley.wright@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
