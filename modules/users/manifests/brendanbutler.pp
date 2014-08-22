# Creates the brendanbutler user
class users::brendanbutler {
  govuk::user { 'brendanbutler':
    fullname => 'Brendan Butler',
    email    => 'brendan.butler@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfCciomph0byzvk/9tYjptBFLDrwrWBxv+7aVMt1IlJ2qKf2R4zJTwoc07GzkJcuLxqjop1qKWh4hglWpC+XvPtPcRfGur9+LIygUjIIk76kpL8lz5wLlVZQ7iq3cgAls3kWaQmt1yDJMzga0wRuBTIDPW4Q18QzNfIcgOEhGdbXNr0AMjQWSwuLHjXvcWHU4mPV5rkVnwyPfuf1vAs5U9gjqr98O+Uy4/cEz8fHzKKqxpYOwORTmBY2aaNbMIOaTr2yP4Hb6w9BJpWTED/4vgMH4uQfvgeCWTnc9vR3mh/b1No8gbHJh+q1xzH2v1XVYaVPVU+sfbTewEl5w8XRun brendanb@sugar.local',
  }
}
