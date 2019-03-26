# Creates the alextorrance user
class users::alextorrance {
  govuk_user { 'alextorrance':
    ensure   => absent,
    fullname => 'Alex Torrance',
    email    => 'alex.torrance@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2CD/mWay9ITFDeetA/V4i73iUe8gopCq7z/PKmqQ8AiWlWfhznplMwmaXIH7hh2pXC9IZ4HN3yMwFTD6ZltlEvUE9EWAcXmXsFOrxEGNMpXlX9hSqVL19BRSs5KFi9gPz7YYObbiVYYzzycYSnojuC2NUuJNJmKMsz7kt0vEWebh6UOc3hDbIzW6UXkPzbNuxyAjSGLIDqOm9nG50SM7BQRhE/Jwcmy7ZeLUIioEunj3HNz9gt6vSBLZhGjrblkGRfYcU8BYdAu3H+3RIYDMOJonYgT/axJKlnuTOcBDaC6AGL+6JKbbkGqykLmtL3+eIpOEyPIzvylNqHNr+q3oRUelIuAH9b0mpqIjTBHe4QjO7qffPLDV29O86HOL5wzX47a6T+mWSL9J9EhbI4obOu50lwMhcAcV8MOpJe4yyCqz8YCRPuyDjhDQgzKw88SgxZVCEIwQrI0vDIrIsLYT8Zvj41/xm0EWhvVe9OVnCqzK/0nT5vIZuHH6NJe6ZEaRwxXaIqh7Sk0yIi8avOENx31weaJ7xlwkjrP6MNP6RmSNlFfXj8YKBQ4xm3175/f7XLfQqc72Soqt6frApMD9hAjS/5ZYbtNfdxWmgETg+FXGXgjf0X4wxN1RDG8FGrtRvzwUWzgQ2Vl0Aq+oG6dzvXFt7kOIi0J6JEPBSxzflKw== alex.torrance@digital.cabinet-office.gov.uk',
  }
}
