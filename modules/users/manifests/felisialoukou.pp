# Creates the felisialoukou user
class users::felisialoukou { govuk_user { 'felisialoukou':
    fullname => 'Felisia Loukou',
    email    => 'felisia.loukou@digital.cabinet-office.gov.uk',
    ssh_key  => [
        'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD0RZYA86wECi/ytHcoyXmphk8TK7YvEC61x2czb67NBgfYbE3gtOfKfuEnK5khEBPga2ch93B5+F5Kv17RwEz9s/CUyWDYixkhzrUvwEGRIu8rqpwohF0TueK8OwYfDb4JH9vigcTWBnZqxZJ98KSSClfbOzlzx2mRtPMtVAD2TvVZH6c4zUcpxicfOzbnaTCQK05RF/EEe3AXzJ42yeli6+kUkqUlPeZJS6jA2BYeWmkrkDT3e+xiH3uc2XFC5lq45F++IDiVFeL8m1O0KshUm286ipxX+q+MDk4lRJ8h3yJ2n37LmJmi1sJr9rBkR64stD8mcBhMHAxcjxkDbejJxCYMJTwGTBotW9XQU/FMC+eV+XsExQgV2nf7SBsLow8zcrLGn25BkP2vqaEt2xSyDi4e5qtZyfyer5P61liSFmHae/t4YzxZ2Vyz1MYMyjmrs/xaZiO/rqpW1ve5hAMR/dgSaP3hnY7x/LHCVfbKbLTrniHICStk0VYeTkAi7X9BdVQSxP8v0gTd20NjQIwKuUnN9HWE+3mBXaVydNs+i+PW+3/bzwswOAy5Shgqg4OzQH7wJczk7efncxrUGQGRxY1DswUheGYRb35TLqC6yzrTTZwJjk+OtnWI3dIA3OVVDTxxpgdZX+OXN9isNNjyMJmRSnnvGnBAHPRpdho4OQ== felisia.loukou@digital.cabinet-office.gov.uk',
    ],
  }
}
