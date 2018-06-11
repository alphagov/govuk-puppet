# == Class: selenium
#
# Install Selenium WebDriver <https://www.seleniumhq.org/projects/webdriver/> from the Google mirror.
#
class selenium {
  exec { 'get-selenium-from-google-mirror':
    command => '/usr/bin/wget -q https://selenium-release.storage.googleapis.com/3.12/selenium-server-standalone-3.12.0.jar -O /usr/local/bin/selenium-server-standalone-3.12.0.jar',
    creates => '/usr/local/bin/selenium-server-standalone-3.12.0.jar',
  }
}
