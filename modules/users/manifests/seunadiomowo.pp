# Creates the seunadiomowo user
class users::seunadiomowo {
  govuk_user { 'seunadiomowo':
    ensure   => absent,
    fullname => 'Seun Adiomowo',
    email    => 'seun.adiomowo@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfwn2PHZxtS6mR3wSHAVf9D3dF270pLYwuwb5HQD+8Q seunadiomowo@Seuns-MBP',
  }
}
