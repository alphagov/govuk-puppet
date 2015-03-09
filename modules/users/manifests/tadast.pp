# Creates the tadast user
class users::tadast {
  govuk::user { 'tadast':
    fullname => 'Tadas Tamosauskas',
    email    => 'tadas.tamosauskas@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDP8801e7Vv9gjhHvhc/l0Njf5UYWkaN57dyqM6+LIMRcmvHKrCzLyKTXKmnnZi1T6wbS41XWShVVW7HD95p3vFDYdXpm7yqfRe80pT31y6rL4V8SNDZCbvYR3axlem4LtMg6mkarzhVu29+fNGO+74bPmoKJnDzBA9jZjlCxm+UPvaeGSmpvODEnsQ5/yC2evaQhyK1GPaCb4lo9RJxtWoTy+eXP4w/0Cms5WtS4HxzRpf7hArFOcDMvGZ1GKLyCcrqYZeuWIi4NStEwN/LAAYIJdVKVLaWxPMjZwNMA1+hQi6I0Oy4obglLhFJhgmZJwRQOwjHirz9z++4TKqRcL3',
  }
}
