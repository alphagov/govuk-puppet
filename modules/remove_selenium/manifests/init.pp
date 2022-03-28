# == Class: remove_selenium
#
# Removes Selenium WebDriver <https://www.seleniumhq.org/projects/webdriver/>.
# This is no longer needed now that we have govuk_chromedriver.
#
class remove_selenium {
  file { '/usr/local/bin/selenium-server-standalone-3.12.0.jar':
    ensure => absent,
  }
}
