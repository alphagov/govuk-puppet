# Creates the andysellick user
class users::andysellick {
  govuk_user { 'andysellick':
    fullname => 'Andy Sellick',
    email    => 'andy.sellick@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCzgYIqGtST23/OgNRRLtJD7m7+Lsvos3oQxuktiRfBKZ8SblLSssbjGC1DJG24ZGT6f+BBROpz86uxEVe86K0NWU6I1UIZZoBHzidg7tyX2WFjgMUBqlgAKkEaKsm1Xp0JiJjPc1bhyf2gOYu+0dng3fiS8hS28J7y+FMx7ejKvcIcMApD/dTgKwePtQT7T1HO3bYRs2lj1dMwCsLjdUyKtysCmRirQC8wVHvUUCyH++Chov27uU5QrbfGWZOa0D+9GZf4OoViNtTD0zq4DbD1ioGHRRi+FRhnLhucwVSrdAwy8fhMO2edhwNLLRnDvOJla1AMO+QshR9kOhl4PRiMbWngxtJnfRmkSlU/5VrFornOntOIS7RNjGoqwgp4hYI3TQ4OP8hXZ+NkPpNJyf3vyfoCDFtkUCJzxvhjbZ0d9T4NTPUdoVjkvUL12riEsX2SD/z9qnEnXFtM1c1vggwUHPX1GriOg5HJ78poH+VGvlwWs2rL/SvMWnBkCnuZsYo3D7CS+k6dCv/DbuobrPvN7sivzJHW5Tcnx0V1LwaSCPDaHUxJFWYUnGBpJDS8/zOjfLa7mboYtFDKY+lpt9g1oC4NYjZzfFQiQrcX/HzUn0thJ0RahzwsOKljDjMG6jway+aEH+YcsEV8HF8C39hAhthI7z1oz7sJBgvNxA679Q== andy.sellick@digital.cabinet-office.gov.uk',
  }
}
