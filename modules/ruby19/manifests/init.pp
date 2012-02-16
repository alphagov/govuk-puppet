class ruby19 {
  file {'install-ruby-1-9':
    ensure => 'present',
    path   => '/root/install-ruby-1.9.sh',
    owner  => 'root', group => 'root', mode => '0774',
    source => 'puppet:///modules/ruby19/install-ruby-1.9.sh',
  }

 exec { 'ruby-1-9':
   command => 'sudo /root/install-ruby-1.9.sh',
   require => [
     File['install-ruby-1-9'],
     Package['curl', 'git-core'],
   ],
   timeout => 0,
   creates => '/opt/ruby1.9/bin/ruby';
 }

 define gem() {
  exec { "install-gem-19-$name":
    command => "sudo gem install $name --no-rdoc --no-ri",
    unless  => "sudo gem list $name | grep $name",
    require => Exec['ruby-1-9']
  }
 }
}
