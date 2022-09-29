# Creates the sidelangovan user
class users::sidelangovan {
  govuk_user { 'sidelangovan':
    fullname => 'sid elangovan',
    email    => 'sid.elangovan@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHWdLamK0evD8DdBEwC3JEcJr85t0FTpam0fxiOM7j2v sid.elangovan@digital.cabinet-office.gov.uk',
  }
}
