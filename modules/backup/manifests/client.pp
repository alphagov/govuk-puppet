class backup::client {

    govuk::user { 'govuk-backup':
      fullname  => 'Backup User',
      email     => 'webops@digital.cabinet-office.gov.uk',
      ssh_key   => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDM1YJkjk/n9JaiepLnDNqB3yBR7gNUITz3EenyRoNy1udi4MVr3m4FFbYEWGCMvyjF/rLdvZT7rE1cRQfDHn0VQcB9+eO7jjaCtk5nz/+mDrtQq+dWWidg2R4cBfnDmyY/JP44ZkKx/TcXzILBRfOuAE3JfYbcgXScl95OmeOdyw==',
    }

}
