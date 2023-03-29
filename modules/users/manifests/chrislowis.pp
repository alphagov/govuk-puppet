# Creates the chrislowis user
class users::chrislowis {
  govuk_user { 'chrislowis':
    fullname => 'Chris Lowis',
    email    => 'chris.lowis@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgamNNn/84WNKyZ9B4wPoV/9oEu3KSyuGGj6JG0Umtu chris.lowis@digital.cabinet-office.gov.uk',
  }
}
