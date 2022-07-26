# Creates the user alexnewton
class users::alexnewton {
  govuk_user { 'alexnewton':
    fullname => 'Alex Newton',
    email    => 'alex.newton@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDaR+cwlFO9Cg4GRFb25KHFCWRBvyn8M2pujiCGjk3Nq alex.newton@digital.cabinet-office.gov.uk',
  }
}
