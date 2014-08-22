# Creates the willtomlins user
class users::willtomlins {
  govuk::user { 'willtomlins':
    fullname => 'Will Tomlins',
    email    => 'will.tomlins@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6OLpZcTti+729Ifjy/DOkMdUwcP8Z/X3ppMc0tROf9+R/acXddweqvOJz8S/5ZcTJK86yn/+EYFZEFw8oGQNpMmDh9BNdwv5AuH7ZFh2Lwe9v0eUtqgDi/AznSif+Ze8BAO4ptQK4yshrWA2anKA6msCI+avLWZqTO8XRz0HSE1jzFHQCZTOJZ1iwDfKbQO/l8E/K4BiFU2OUfOVVEaZVd8fS8U44GP7PhAMIR6X2azT9glizDv8WrwqZWzMrZBjmPYrOT9WN7wH2R/zND7/FbekIPF87cnQW4n9x1C2k70MZebNN2/QgWpvaSSbJJ2o0PTLNZ7fxMRfH0L35f3J9Q== will@Dirk-Gently.localssh-rsa',
  }
}
