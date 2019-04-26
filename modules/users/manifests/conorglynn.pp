# Creates conorglynn user
class users::conorglynn {
  govuk_user { 'conorglynn':
    ensure   => 'absent',
    fullname => 'Conor Glynn',
    email    => 'conor.glynn@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQChXVB0+ZEc2KB1147WHGbhSUGyB2xeLnwJ4CW9V9hWdTgGWMuiWOcgFc1BGGbQ2I6Be939/JzqmsNOlguB0Qq5OJgcHelgB2+qAqEb1I9gYwKFFoIOIpiG5WNNKfbY+C2OjW6zCy9n0bNdXuSDzG2becfeCtSurdoVQNwt54AEXNtQAjUqPk+T4pHpMdWpDIMamDw8PY8PG3hypr6ao5vy/vBOaIKezAGIsDnr8eVIVkaV/TCE9RRQLxpN/tXCowzRbAmIko7so5iKoQOXSzHLMk/dehDk4oQg8pdRG7n/QW3NXFg1KbS3STgUb/8uigwAVRWCEd9LysDaceUISZ2JOP2f692f/z2rA1gCQiM5qJBOTGzL980PfcnTcKA8LI7A//S+UdWEONThQlpnZf+aFTaLHLvuBNO4awOoMorDkI7FMUvyGTHKJVHqebHwBoFMKghn9tzQ/GKK+o0zNgZ5nZaVGRRzRhxv/UueYVPPlRAf0w5GRPzx4vyOc7PE4M6amIDrIG8xojVFn8m3KwQumU78m297HzWtK3CSJSDrU1k2gpHdM/8AArRtYhIyPl7w/CaC+GrVMpG3I4r1HFzR92qQ66aUanoqr40CXwL+kbyZirt3u4km2c140/qX3UJQYcmObk43MjepFxuVmRIqCqjsfBFp4ZpIqOhQdsr37Q== conor.glynn@digital.cabinet-office.gov.uk',
  }
}
