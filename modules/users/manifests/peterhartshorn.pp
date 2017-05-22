# Creates the peterhartshorn user
class users::peterhartshorn {
  govuk_user { 'peterhartshorn':
    fullname => 'Peter Hartshorn',
    email    => 'peter.hartshorn@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDC6xtvLOlVek5ueB320zQ7w+y9y/M1XlxT58J3NDLjDCFuon/t+zXA2Wr3szpINtrMtr1wx+9WTBytMThAWTRi/P4aKfh7K73tMSjmgCmh/kx4HcgGhRRxz3bON7KeLRjy6BpEe3w1SMFn8e9US/eH0y70dJL42g9IyauQWlq6cvMgJrSIcOZXnl0QET8x0cBd361v+hJvh7bCHfct9hJI/Tx8mDfLLykFyan0USqfACh1Z6bXMorLZZRt/hXxkVJ5GAC+8bSVG4etDg96BWzVMmRX7YxTKjYwk4oPyoyET0WCCSoxaGHQkSC4I1RPdrGBjFaOYHskfi5lrgPqFw+H6FaYGX78X2p2wj2S2rFihPHyPWuPsoCVDlFFdCuTry+FlIJ93AUXV/6MWSGTY3MZqeoa8F9uWtTNrsCpkEQyGWwEVg0a7mQLFm9E8Q5q08A/Mdc6cF+LO3NhCo9XsoFeWeNgqZa40V2QYLvRVnQzEbmY+dERr8tU23GkA0ZnIyorlNAOKbjualWYFplR4C57SmD0JRN9Ksr+L7KqjHRy3R/U8doDr/Dm1pGA26RXItMAAyecesl1TMlX83VfsCRhFqIRHm8cYy6noCWZb8f0wQnNYVY8OC3M34mNg0WRtJLqdodkSP4la99vJAjIsCVMnUCtHTOHuohytJUCALoEcQ== peter.hartshorn@digital.cabinet-office.gov.uk',
  }
}
