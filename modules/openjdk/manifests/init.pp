class openjdk {
  
  package { 'remove-openjdk': 
    name => 'openjdk-6-jre-headless',
    ensure => 'present'
  }
}
