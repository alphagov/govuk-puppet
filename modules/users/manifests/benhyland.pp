# Creates the benhyland user
class users::benhyland {
  govuk_user { 'benhyland':
    fullname => 'Ben Hyland',
    email    => 'ben.hyland@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDyWgcHQkkn1gJipy2SFr5kUqf7RUEQtefVQ0rfBBzLraUyb9uWKlJvD5qWHpoL1M++KsasGUHWy8kp3s7XPM319de/6v5q9e6qGZ6JkwncMcRTWW8nuw7c+AC0qJTFwBGQTIsjjiJJ12VeyJ15aTb+wBVh3T88ADDWfEeT8MLGbCOBzxWvoQUH7JkIXYlQVpSlKTL0sAkwzgpxo1X4lI0UmAEFMewaSSRyKvnPhdco4tqdW8fR+tc4MwmGF+FvAbbc+/lwgJx1bMvlaxQKcWW0DPT5UvDvllzP45QY70A4qE1vAcEqjbnHs1NK6q+CLxVvsukwj17jqW+sbocsjUkTm6Xj8ZNdw9p17sjGNsTCshwFNNXvmI0MV+Ni8FR8erLLf1BZmcYoOxZFVSiWhpNJKVb+cm24TNsp6FJRkPJy9kYibrvQ4fsjtkyZw9J6BNFDvcmQlMLUxUQswXFi1TMe9NbFnSteLp8TknRU1j7p7ufiksEpd9qnZUF8MOqxcDomAlyRpSlsvGT8ioD8+BdHyTJdA9sZImvQjFkNDJvycae7G23ut2/NA4mfxgoWqObSEcYygS7NC33zrb9gMooSX3S2PmWS4YUlm8DJxerFxX9mapj2otoT3mC06fom9snOyqcYBilDGDApfr9Q3NULX/I8WQxj6O1fFBDhwP8Gsw== mail@bhyland.co.uk',
  }
}
