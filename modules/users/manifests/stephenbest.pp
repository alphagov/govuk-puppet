# Creates the stephenbest user
class users::stephenbest {
  govuk::user { 'stephenbest':
    fullname => 'Stephen Best',
    email    => 'stephen.best@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD5eCZQUNa40dsEjzxhokKFcOVwhxrxMNjscfU4cKZmJf3lWawdG788Fxe4RBzS2g4n2hOTTumhsR9OSJZrUXAFE71hUNcLc8V41vLvweL9p36C9qMZItV3gZtY6tnRbPvDzDuMFImCYYhXm+C4frBwH9eUVzpd9jpWbHpn/40UjNjzlXd29eeAArBi0EZ4ZlmoIrww2NdthpTFXGhf1kGbaIcuvE8csqTw+p6NwS4Tq5fpxKCtNbhqNOHGsZyACv+DfTtSvcnfXHWI4UJnhhDngOTBrADd1InQVs1w6Nnb4Ao4cgWXq3i1bkq0GqJ+3WirxXGAQDZjUvv4TRyOUM5N stephenbest@Stephens-MacBook-Air.local',
  }
}
