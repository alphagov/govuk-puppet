# Creates the lukewiltshire user
class users::lukewiltshire {
  govuk_user { 'lukewiltshire':
    fullname => 'Luke Wiltshire',
    email    => 'luke.wiltshire@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDPtK7AcJ4FGYoDZ9gXCyAD49UZcJfulQ56Zf2gI7c+N6A2WND7vCdcEvAm5oG3FjUThBcqNNxVardNQ2fXrFf2SX/QoeQ8HfHCFhVsKiaUcqfFiaEPHWownXx+i+wtFVW6ck2zLe+3zZKqBfr2OmCiBCCQg5mf0gP+/BNUyHAY7C9KzDj9zM70NyxCSUllkywV6ZDxMlgYeCvk6H7Bs+AlxwrIusqrZtJ1fOSiC0e/QCZaEk+uny+3UGyPEyXWdnXvukUuzM6v6Z15MFrmE4AHk/RffVcbYmXzXGClhtqu1BqdvW8PPNhdeq6FBWD7twS0TOd+pDXp0L/hxYDWUPSBWMo9evrVneNwX+YXYsvbAoPPZVT9CHArGyKawvMAbC4q4GYBGH41fE+nNMTXk47QCE9mdMQvgl0v1jrmDfRUcY9OL8XtwYMFcFurZGx6O3op3sCYhDSUuNKS6d3eLLor5cT1VfSCnNzpepHWaFVFMQ8loIXoTkOKD/Y0AfLYnZwCNsQtdNN7ER5CfxBSPLO6ZBtc1cBl5PNADI0wzr+HJhJo0U6bG1MZWVX0gvoVyhwZZhyncE12n8l/Wfwjn3uL0O0C+XYNY8z6CXIS2Gb5Xhl9B9c6Ix5zTaaNKyQ4Nx+3nCFjimvZviAmZFUT1Q5tSfNm4+l5InfvFMQopxz4qw== luke@lwmbp21.lan'
  }
}
