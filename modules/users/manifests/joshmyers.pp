# Creates the joshmyers user
class users::joshmyers {
  govuk::user { 'joshmyers':
    fullname => 'Josh Myers',
    email    => 'josh.myers@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
