# Creates the peteleaman user
class users::peteleaman {
  govuk_user { 'peteleaman':
    fullname => 'Pete Leaman',
    email    => 'pete.leaman@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAgEAlCqMuykoxYHfK7eLuo6n68U/o7b9rVIR43YWkCrwlQ4Hr3s+b7pHZbtkdkweZP7LdKJVsAGBE14jFiLv4dzrAaRMgQuev1paArzkd9ObKDb/TwqSqPHdrwbckDoLMBXvqTvhRG+rdORLJX5t3Or77dW+TAyqOhmws8E0dFKCMX7Ct5OUM/AemB6x3yFxWdp8cjDV6ENvzfmrbaNUhRgl9M2z66Bs8xIHPDgu+rUESAFNzfZNl9oJMycQyN3JwydPsOBZWYWDVc4zRHK6VK+kecT9OWmAd/kdfIR5Wjgy9v9D+O3ipo9xViV7hs0/0dOEA5qZdd+dJNjWkG9/EahntAmXZ99MxmaNQV81gZY0PNhFaxdgvzR9+bch7GaRzE+u42Pg4E3ydNBtlsAnZByJsf2vPfoHCMWJK3ZUERpI6xskbFinNIYQEu9v9xqxIpSVLvciKqAnYFW4sl07c8pAl6wQC/P2RSxK19IhvkftiZjAKAg1LX9tt+Gl8LH8wVgQe4FFxv9zopXvZJLa4/IFclQvXkJVgIHIT/OBX8DnihmHm7i54CWkjXR6I8obM8rbzAqVbavF506xp4Z+1PjIr1nQaPPqDm8JLH/m1fuUZ5c1dwFlvYJqq95B0tTUKhBR9uPlKWw639ok36wLvA9JWwv2eWEZSnpYTlVCatP6/GU=',
  }
}
