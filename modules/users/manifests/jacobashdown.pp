# Creates the jacobashdown user
class users::jacobashdown {
  govuk::user { 'jacobashdown':
    fullname => 'Jacob Ashdown',
    email    => 'jacob.ashdown@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDM95amYidz2LjxoyAyuHQL/lZbOjPR7aqDDFb1D9bgDDNiszuNmMCdMTfDM8PXAbwVbOEjFVU2PYY+ktN26+VzAHJi5nYoKMfH9vedpau1bhg1/Wt49XYQ8hFpRt6YTU7/jftb9xPtywcI4m9qeWK6He+vHKEHo/O4kMWZN8KtY3xRr1JyMH27yh6jx6lVBIsiicTmzmKmzL1MfSzWOBGbUxXOnPbXTSAmlSVD264EaA35Q0fbzEBD2Pc+6GXCHLSp3jZa1+RcBmrhh8L+sFwoJSmp6ES85GfyRiWSUiD289tclOU2Dc6gBCcXjXiGYFCHDzdH7xKHnpOPoGLH9rNT'
  }
}
