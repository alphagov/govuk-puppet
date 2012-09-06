class java::oracle7::repository {

  apt::repository { 'webupd8team-java':
    type  => 'ppa',
    owner => 'webupd8team',
    repo  => 'java',
  }

}
