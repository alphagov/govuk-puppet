# Creates the carlmassa user
class users::carlmassa {
  govuk::user { 'carlmassa':
    fullname => 'Carl Massa',
    email    => 'carl.massa@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwJw/7iUKZXDsjx7MC/ie4Uvm5rnz51vMhiJhOo+iW35JkECqIg9m103Kx/wCQiOSSRnWCYG9+p1UAZGAYlgURS4z0IrQkGmw9VlRl3/gb4VHROtSY5nyvP12y84WZdWXURTDhaRQNfbFNn2OaR7o2pieEdnUHQwOuw4u2cLxF+NosFW0p8jA9oaeyfKTdMa5gJwRVoeyRb/9LtMelqV+Tt3bRL2xCXY5x63v/g8i+U+jpzWouZTb5/vl86wf7fpTjjy0nIjoQ+C4C8BzgVP5oHx9r2czfXD62JW/7eURzhhGz3Uu0cK7ZN03AwfDbQWUHqsRFO0AsmvZpyhXYVHCV',
  }
}
