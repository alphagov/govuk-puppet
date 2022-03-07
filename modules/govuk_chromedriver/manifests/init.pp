# == Class: govuk_chromedriver
#
# Installs Google Chrome and its associated ChromeDriver
# Used by Selenium tests which need to drive a browser
#
class govuk_chromedriver {
  require google_chrome

  # Copy the install-chromedriver.sh script on to the machine
  file { '/usr/sbin/install-chromedriver':
    ensure => file,
    source => 'puppet:///modules/govuk_chromedriver/install-chromedriver.sh',
    mode   => '0755',
  } # and then execute it (-> denotes a dependency)
  -> exec { 'install-chromedriver':
    command => '/usr/sbin/install-chromedriver',
  }
}
