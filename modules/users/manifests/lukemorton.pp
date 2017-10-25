# Creates the lukemorton user
class users::lukemorton {
  govuk_user { 'lukemorton':
    fullname => 'Luke Morton',
    email    => 'luke.morton@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDh50jnjnooyQV44HFzuo6G0oqOVYxGHXDP0E4X0U3LhxnaZPH+0DCpusAODBOTR9/7OR6Gi56WBsgQOe1b1zpno7Dp1YQnKUNBANAFnaTID1rtJiEEDzSgQxAr6mP6zc88gvia3jwIpk+PhoglG6L2NUrHGIsHN9e2BtpTYgrVkju4eS1wtogtLDUGulZhvVAmzZ/2Va+pQ5v4k/VE6J1M+oY+5JnCtKk/jWIO9mScAav13ThXs2wDj4DE2I2wggOkZa5gI8u+meFhDtKlNJoEsNUSXXJfzmSIVdSGtrNN5SN+2tFWHkmlCHUgIMn7Sr6DQCterRJr/Q6IW2EDxDTsEzYqEb3lZ1KygAztgcsjijL33hBRWJscxvRMen5zn+/FpZCk/f/0/vcUbWNZ9xER3N+0QxKekSVF8GAlQPgKPzKilz6op4yi3wOD4GfSnyKqFUG+Lsjdb7YXBhoaQflYg581V7PwkYo/y99Ygbx0eoN0aizWv7bGXOC74/uAmPdtP1gUkp28D2MR7E2di1LNC8sq9m11mkPT+XP6mAoL4HucGwTwL9/xuZ2vW5YkVgRCiWtxr8wfFseNBPOfnPpfvsZlH4Q51VXWw1s1DSv/XTTxBpC0tkaPuEwMavonzG2YCQ04vtq8en3iNH1zsBV36ZhWyci4D8zIAwUQ84lxpQ== lukemorton.dev@gmail.com',
  }
}
