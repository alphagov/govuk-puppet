class java::sun6::repository {

  apt::repository { 'sun-java-community-team':
    type  => 'ppa',
    owner => 'sun-java-community-team',
    repo  => 'sun-java6',
  }

}
