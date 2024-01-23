# Creates the user andydriver
class users::andydriver {
  govuk_user { 'andydriver':
    ensure   => 'absent',
    fullname => 'Andy Driver',
    email    => 'andy.driver@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB7ncs1d27BkJRtqb+BiiIYe0ZzU4my5IhdZlauj1EVL andy.driver@digital.cabinet-office.gov.uk',
  }
}
