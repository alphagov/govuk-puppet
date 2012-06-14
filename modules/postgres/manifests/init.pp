class postgresql {

  case $::operatingsystem {
    'Ubuntu': {
      include postgresql::ubuntu
    }
    default: { notice "Unsupported operatingsystem $::operatingsystem" }
  }

}
