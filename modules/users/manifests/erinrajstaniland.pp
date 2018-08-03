# Creates erinrajstaniland user
class users::erinrajstaniland {
  govuk_user { 'erinrajstaniland':
    fullname => 'Erin Raj-Staniland',
    email    => 'erin.raj-staniland@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMcNbnQbVVQAse1UUD8OD/HuKQJ2Divi6scGvNKfL4ai erin.raj-staniland@digital.cabinet-office.gov.uk',
  }
}
