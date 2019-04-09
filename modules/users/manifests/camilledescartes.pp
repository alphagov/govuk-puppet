# Creates the user camilledescartes for Camille Descartes
class users::camilledescartes {
  govuk_user { 'camilledescartes':
    fullname => 'Camille Descartes',
    email    => 'camille.descartes@digital.cabinet-office.gov.uk',
    ssh_key  => [ 'ssh-rsa
    AAAAB3NzaC1yc2EAAAADAQABAAABAQDvmwW3c2UsYY3jHcFgtoIdbq2rXBAWz3tiusaXHwEQeuOe/NhIc6yY4u/Oj2g//9gDBGXJTI4MawO+CD+Jtra7D2nrZ32aR0sRC8MwCGx9ph2omEfkKg3sxX4gPuwEGGnqJBcFyetyli+P1/ttq4oh5F3JL9VGhs3kO2Jy7uTKm9tgGsKrxj+0kizUfSyRvl+kiedIsygZEJnmh7YjRz9VC/eB6Hd2W8L1sbK0ozBTpzx+MaAlGhI61vuvKOCSUDW+xDNtYdCupuMNjOXOtEDNtKQV7+MHJZVimP13/6RUyZXAPXOuAiQ5RPF+RhRHA33aD/6nuH1It1Pjve/CCV7f camilledescartes@gds5029.local',
    ],
  }
}
