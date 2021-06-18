# Creates the alangabbianelli user
class users::alangabbianelli {
  govuk_user { 'alangabbianelli':
    ensure   => absent,
    fullname => 'Alan Gabbianelli',
    email    => 'alan.gabbianelli@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7dX+lZIfTh7qenpuWpxBUwxmAtop2NrVpW/LlF76LSQ31Wulafz1n3aEIU3aF1bit9N/e+feyeEmC7mX+00z2vlA9EtIWfr+AmubgWhj8jhqwsWCRMDt2XG1jV2aNlWvc79xFIMEedJMN/KO6CPmt8Li3ot5EuxMHgSegw+Ou+LP4vek+LBCNy6YNv5TQ1+iiH9M05zYOeFBA9zU5XJuwippxSEAz4TbsRCqM4O2jw5R3/aoGb6YQHh6hI7bQJVxh/p8gCvroLJpU1nXDn8Ntq0NFmXbM+3DpVj/KGq+YQ7KCfxnhRcAkb48GzqeUkkKE3s2ifL45lcXTSW3lFNuq+zJ8f3o1nv9Qj+TV3pbZPf7sE/k3WiiuE4Zv7pBeZS0gNvXxFmFT3eE79FoRiL2qrSTx1qPIz06y2LlCrMQnYK/dWCLX6HXgXsdwSF+qMUVqb9jys2/Ze1xkSlfUB9FKNdativmnyIjXsrqf/yDouSHpo7LuMA/blVP3kRgvgYQVzRVcH6ehYag1aSr3XwI2+b+ZT++UFfkc0YyzHmLZtfr3QB1NUYW9Bf8mUoCdK+40oQhjYSNwfomLbLrAIcmvd1ZNHBiym/3HZyjzJ9tQXdFdVtaWKgDHGOcm/mn4HPuFjeTWpB2tSsSqsxMBrHhWtcNM1yK7ozdDQDb6SSZQbQ== alan.gabbianelli@digital.cabinet-office.gov.uk',
  }
}
