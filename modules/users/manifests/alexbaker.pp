# Creates the alexbaker user
class users::alexbaker {
  govuk_user { 'alexbaker':
    ensure   => absent,
    fullname => 'Alex Baker',
    email    => 'alex.baker@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbCzicUco2TIwas6wuHr2B1d5wsXX3FlrZLsydhs3L1 alex.baker@digital.cabinet-office.gov.uk',
  }
}
