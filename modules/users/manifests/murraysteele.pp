# Creates the murraysteele user
class users::murraysteele {
  govuk_user { 'murraysteele':
    fullname => 'Murray Steele',
    email    => 'murray.steele@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDLjjQ5qyX1S8aHT4109z0hzEhB1z4oTXecFVIV7haSooWJmJTV2wmrbfhoSs7zSNPKk2nAaqSAn4n4+rK7LoMlUOaWVzghXF67nS2UzWNVNiU/9TdSko4aICjp7HyEHKF3eXI36YLYxFjgug6PgOUEHqdNgVU2zMYoOu+zvB4VDf4s22ggjjHVYnetXKhWLJjB0NQH5tVzGHCd79Jn6cg3wAT1UzvhQ8YpbdNqhwdgo/q+lcsngbwYH1+BHySltqi0aJ9KuqGjKEb6+/rROhIHstIjVjFfukp4JApU1kw5fzcPH7oeP1ADEsJmEbR6V5gkNpj6pSkIunrVH+BZNGRnVtNOJcjbcWeU7g6T7z5Z91Kl9MjaZoGecdnpAFwh5z5pBR/OWjNqv+B1bTtKnWHHVi9NCEteCQ70OGlwc139rEsuUwHr6Nh7+q6t2Tn5BmiSAsPLDCuVeEtDE6WKiFZtPsEAFSzKvm9c3JanycAFeRM4Hx8issYDMGgu5HGVjqxJh6BxV/RtcfcOLs7eynHIBg3uumP8NQAjxr8BDjk+tlg5z0e2wq3dViMFDRohNI2IfKX3aycfWgLI2EY+Tj2GeQJHLxbjFRLWufJp0CwaOQ4EYvNfCOItmZvXPiKi30UYUJJRbcVZGZzM5QY+ebmgU+vjj281Km6PKKK3vMbv/w== murray.steele@digital.cabinet-office.gov.uk',
  }
}
