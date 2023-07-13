# Creates the danmoore user
class users::danmoore {
  govuk_user { 'danmoore':
    fullname => 'Dan Moore',
    email    => 'dan.moore@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF9exfPUcNvwA72BF+dRQ0BncR9KMzbXjSZY4BQnYg04 dan.moore@digital.cabinet-office.gov.uk',
  }
}
