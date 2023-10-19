# Creates the andycollon user
class users::andycollon {
  govuk_user { 'andycollon':
    fullname => 'Andy Collon',
    email    => 'andy.collon@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0xJiQoysII1uABlLwj+tkGh7rxc55q1YIhNrVjEIVV andy.collon@digital.cabinet-office.gov.uk',
  }
}