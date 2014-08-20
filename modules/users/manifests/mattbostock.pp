# Creates the mattbostock user
class users::mattbostock {
  govuk::user { 'mattbostock':
    fullname => 'Matt Bostock',
    email    => 'matt.bostock@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDeta2wY+w3jrzguXtyj/vrRX4RfFdutczT23HgdzyTXjK3Me/sI2s5Tw8RlF85PejupG4lVIivIeV/l77WxcCT5PArmmKyRBFLSqM9CzIpN52mxIQSorDpXoROqIYK1vyaAp+rsHRON3qWxzdKg41ignoPt8GUmMOZsZwjCLbiiDPqL9dkpUYmbdBzj8P7r8HamznLMIf4M/tZBeoOX4lDf6cK5DjEalGjPZSoWDdZVxzyf74iqFxisxjxPWjMjy8Jhe3Xq8MVrTjcz5c+J4zQiZsxffyWR57XXzyz79KhvcbJaGnmQwu8Vpr6txrPXDd8CUirRhMDEihpahdvIvnecDnXxJA85KfhCHSGSm9Sc1ukgObd+uLQcDRFYt2o78yLZWtz3HNK3wVL0sjhrfhl17/PD8BMQ6qkZGXb5B5toxYmts29UJIEV3PwSG1U6MUZe3KTm0y+LJnQzEpK9tUFZzlBBrRhrMfbMC027lZpOsHVPu/LBrrD9gcq330RgG7Uik2n1m9XcEjiSTkEc6rttZyJ00ZRl/KK1h/A2j6qA6y/vAxsaVgCzX8hvNOr+VDbBEgZUZiDq0DtZRO2xpjaFNfmju5JTvYIiLNktcdoXrXszRWDw6nWQByDw/ZvjoRNhD+EPcgAciB+gBuWJN/BfBvC0hJNI+uS24gx2svMsQ== matt.bostock@digital.cabinet-office.gov.uk',
  }
}
