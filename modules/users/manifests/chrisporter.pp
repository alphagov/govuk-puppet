# Creates the peteleaman user
class users::chrisporter {
  govuk_user { 'chrisporter':
    fullname => 'Chris Porter',
    email    => 'chris.porter@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEArlbLi6lVFLXUGrMcu3XGPPwJ9Ju+ndZNPWhgUGhVWOyG+pWIRml2tGPHFVsGUnCGf1RDhQO1/E6vYmMwzFEd7svdBtLh6tWLo5liecC+spPKO2YGLz0z+kwj68otzCKu2Et21jXnm58tMpF7xke0+B2ImDFmggyvb9EUX/JcgSetebUXCBA+Fsvxa6ucEFPSPwcIkrqxMyCY0ddWLb9raJj8XEhiAm57qHeubx0o4SgN5Bl7WqLheVzrDYmcUVNSh4QJvXG7wldAmxGNCQF42PLdJrKOi42/tFnkYhN0Sn+yhcwgxK5D37rJwNhkKUMmngCu/eDjLKz4DO1wxDmjaw== chrispapto',
  }
}
