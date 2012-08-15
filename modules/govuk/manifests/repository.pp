class govuk::repository {

  apt::repository { 'gds':
    url  => 'http://gds-packages.s3-website-us-east-1.amazonaws.com',
    dist => 'current',
    key  => '24B253BC', # Government Digital Service <devops@alphagov.co.uk>
  }

}
