# Creates the stephenrichards user
class users::stephenrichards {
  govuk::user { 'stephenrichards':
    fullname => 'Stephen Richards',
    email    => 'stephen.richards@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
