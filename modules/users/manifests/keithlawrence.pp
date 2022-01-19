# Create the keithlawrence user
class users::keithlawrence {
  govuk_user { 'keithlawrence':
    fullname => 'Keith Lawrence',
    email    => 'keith.lawrence@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZpRIEv2s97S8aviYVQg2xqGZSdACQmJbz5CYtsIhv0 keith.lawrence@digital.cabinet-office.gov.uk',
    ],
  }
}
