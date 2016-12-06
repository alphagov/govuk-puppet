# Creates the digitalassurancetester3 user
class users::digitalassurancetester3 {
  govuk::user { 'digitalassurancetester3':
    fullname => 'digitalassurancetester3',
    email    => 'digitalassurancetester3@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD97CynStwWbI/g4ovWMxD6vrjwfzuKxOwHA1Ol/KinDWTdHUQZGovchIfLOzDZ+eOocMMlIrltVWtrkP89HecT1goJV2i+eU5+4vrIBadcIsbwyvepgcoiB1jE1CTa/lgbz2HK8+r36AEdYhtjBcwJ663wSJaVxiQh/3r36Wy2WK4U2bRh4wz6rPhSRK4HUuBrgxLzDpj4a8OdtuMF5UtzcOm1FcjjEEiMKxkk0cQAcutsccJ+26HyPrJseXhuJyq9zE8LvKr6eRxwvJCryB0CbEu0maT+cXoKj/yCv9UQ+kFW7s4UmT+4EioT5jigB8jtB3Xwo6SieIyfl9tg6tbl mike@dawk42',
  }
}
