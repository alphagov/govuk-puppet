# Creates the joskoetsier user
class users::joskoetsier {
  govuk_user { 'joskoetsier':
    fullname => 'Jos Koetsier',
    email    => 'jos.koetsier@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCnNazgxg0cJRgZMQ8KxZjdonpi0Z+y2GZ0P8PuuaerLJfN36G2f3kEeYfOVOcviAReSpqToqN70MSazc77q8NCbVySgQ6voAyxUS063kMSu6Y4OgioP/GSf5SFK161rLiD04WZ+gHvLhTm+JlGShz/nDi5g/f38YApR1ersmVT8BqD5cWEJic/JppUwpCVHYoXKkNfjTbc68EHvfGMnIQBp72RtG4RESjcj5QVk5uCj+n9zH3OMaWMvU3Q0tuvhQYZiwHiVwKbs78qd2vS4+BB4rRebNsSd/B2kvaBR1VZcxbwXeODpWMVN2L8xcCzuzzlwRZIGm2EpZCcofm4Pnkd0FR70bh1UgbQDCIQdtCnb3Gbhw9YlOFfUjBOVQl6fbYh3yEvk6ZNiUmOVqt9kXnBxaaKbGJGPD3yHoArBDBAntdVdfyzXc5FSVl84hA1x6y9NXcaU1bWg0iIuSaXuDBC1xvtfdxtzqkx4+0vPHnx6zE7dXapGeXiEaK4QgCh1aeZtbOrEhllHsjzUhw6WQscICIghLoWsKXfiuZgRZxmaU83C3rHk4Z58c14iJ+l4qLiSGFXNCxW8QatdeCg3jMInk6I8lCMq5VHeAb1uSCvRHn8C9nA/FrecwXpxMfM8Ms3JSydOTfBbplxVEcNocc5TKdo/c3w/hCrFtPhIEFtmw== joskoetsier@digital.cabinet-office.gov.uk',
  }
}
