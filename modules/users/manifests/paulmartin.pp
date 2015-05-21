# Creates the paulmartin user
class users::paulmartin {
  govuk::user { 'paulmartin':
    fullname => 'Paul Martin',
    email    => 'paul.martin@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIviVD4wrfZCHTOpgxeo/eclomz2vNdulqJ/hKy8fk5arI2IlfqbgH/eP21IztR7KfO6CWEi7PeeUKX4cQWT8pIo6vvxqnexnLzDJ5JFEb/y7tjqHNFNWoVC45q7ZHVQNvnHWXMzpO0zl0DvnNVrnOfgvPiy0HH6lI2O9LFkHqx1K7tieCvaNea181eT/Q78ud4NVm7w+xfFz0jX/79p9Ilck8f3/HAlz7mBb97HjUvkeEjYmwdXqLa7MOAK/V//QIe3OXbiL4fbrtAooUkE8NtR55WgbBn3NZkeAN3dveq2+OdygbzvckxlOpuASExen95k1pz3ZZayD74zIAdH5t'
  }
}
