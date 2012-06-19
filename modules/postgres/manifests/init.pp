class postgres {

  case $::operatingsystem {
    'Ubuntu': {
      include postgres::ubuntu
    }
    default: { notice "Unsupported operatingsystem $::operatingsystem" }
  }

}
