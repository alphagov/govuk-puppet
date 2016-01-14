# Creates rosafox user
class users::rosafox {
  govuk::user { 'rosafox':
    fullname => 'Rosa Fox',
    email    => 'rosa.fox@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCctajq+RyUOUwy+vrC3P2lsmSGec7mVR9FV/M59WK3B5+EIvydBd4uGJxxqEaj/F1r7q8M5h3Nqt7vdyxOZNcaC8JgT1Pr27HYU2d8s28Jd6wbvrgh+w+oqF77CF2GpUfa1DTvFT8EK3Jd0EidbuaW+qPuloVv3mFuSB+3htAWbHp6bgBjUACkzd3S6K1mnl2vQ34Rzml6hwL2xPzI5fEVXnmszt76ovrj7DgL7YD2E60P425JfLfYXrdmNWNPXV4hMLUxfPpinuXYRUIKAfy//s5I1JEgrrupj0+GWbcAnCcpVXibRXpcdeCFelRGQrkf+A4wafzqulnxH+Fuiw0dI1G0lYL1kwG+VL6L1ippS56fPlTGHzuXZjuwOXjTSilfNO1iWlWnBHLqKEng7N1voRzEOpHJFmjsHZ9sm6YVMh/27kmcYtqdxJph3xd99kLzvSxp3uey4Gtxws1fyfx78UF4jCjgwXBE62SM/1fZBrN4EvEhCUfqr57Gd+FPxxLSWz5tzT0vjAHdl6QZzkpNNm0QWCS9Xr706+htFHibuiCx5gs3TEsr9sbHx8EWfPFMxMqleTL9cvsoGovAW0J/ku+MgL3hKwItKRiTDGt3KTsLTOT/Rez5xfOttm3TMKxd1Qq/qK2ZC93/gZOGtSflnz6/U2z6/PnKphs8VOkmsQ== rosafox89@gmail.com
',
  }
}
