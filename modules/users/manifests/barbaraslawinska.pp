# Creates the user barbaraslawinska
class users::barbaraslawinska {
  govuk_user { 'barbaraslawinska':
    fullname => 'Barbara Slawinska',
    email    => 'barbara.slawinska@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICEXuDDKjxAixiyrAKS3v0ajEtRM2oq/xB3fLN46nLkL barbara.slawinska@digital.cabinet-office.gov.uk',
  }
}
