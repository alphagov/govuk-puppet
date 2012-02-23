class openjdk {
  
  package { 'openjdk-6-jre-headless': 
    ensure => 'present'
  }
}
