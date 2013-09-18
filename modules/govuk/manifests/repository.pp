class govuk::repository {

  apt::source { 'gds':
    location => 'http://gds-packages.s3-website-us-east-1.amazonaws.com',
    release  => 'current',
    repos    => 'main',
    key      => '24B253BC', # Government Digital Service <devops@alphagov.co.uk>
  }

}
