class jenkins::master inherits jenkins {

  $app_domain = extlookup('app_domain')

  apt::repository { 'jenkins':
    url  => 'http://pkg.jenkins-ci.org/debian',
    dist => '',
    repo => 'binary/',
    key  => 'D50582E6', # Kohsuke Kawaguchi <kk@kohsuke.org>
  }

  # FIXME: `ensure => latest` changed because 1.521 broke the envinject
  # plugin - https://issues.jenkins-ci.org/browse/JENKINS-18614
  # It's not possible to pin an older version because they get purged from
  # the repo. Disabled until a) that issue is fixed, b) we switch to the LTS
  # repo. This will be more stable but may miss any security updates!
  package { 'jenkins':
    ensure  => 'present',
    require => User['jenkins'],
  }

  service { 'jenkins':
    ensure  => 'running',
    require => Package['jenkins'],
  }

  package { 'keychain':
    ensure => 'installed'
  }

  file { '/home/jenkins/.bashrc':
    source  => 'puppet:///modules/jenkins/dot-bashrc',
    owner   => jenkins,
    group   => jenkins,
    mode    => '0700',
    require => Package['keychain'],
  }

  file { '/var/govuk-archive':
    ensure  => directory,
    owner   => jenkins,
    group   => jenkins,
    require => User['jenkins'],
  }

  # Set the session timeout in Jenkins' web.xml file (installed by the
  # package). This is a bit nasty, as it just searches for the </description>
  # closing tag and inserts the session timeout customisation on the next
  # line, but it works...

  $jenkins_web_xml = '/var/cache/jenkins/war/WEB-INF/web.xml'
  $jenkins_session_timeout_min = 24 * 60

  exec { 'jenkins-set-session-timeout':
    command => "sed -i '/<\\/description>/a\\\n  <session-config><session-timeout>${jenkins_session_timeout_min}</session-timeout></session-config>' '${jenkins_web_xml}'",
    unless  => "fgrep -q '<session-timeout>' '${jenkins_web_xml}'",
    notify  => Service['jenkins'],
  }
}
