# Creates the maxfroumentin user
class users::maxfroumentin {
  govuk_user { 'maxfroumentin':
    fullname => 'Max Froumentin',
    email    => 'max.froumentin@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvuBdxXkJ2Htbt47fm/CV7+uQLOu//OJ7tJv4mlyM0nChhvvI56ZjfYRCdcZNH+eFXzUDUDh1/HK9J8tA2J/ZTg/OqS+UMylQPdc4+LxPHDenhZjvCigf0Uf4ISJdprTCPJj11I/wc7bq1m6C3HGwK5DWAmSIOh7rqLDhuDIZIKdlx3nz8DEAmUFutcA//3sCfHSd8n3B6Rvpzhw5wqqJhG1nS7upJir3lew+XHt+anu6J17iGHTKKuSlZ9ZgXP7poQPizIjIK7sAkI6S45gLcKtJpbMd5pt8Ze80GcH5qoycylz93kUhy8jQJUAR97eDxh7odaFOX0y+Am2EcDJ33PsjDu9QCqJOQu0NiXWLobRIyqtDo08cdDg7yBYgAg5GuPAska/lCG9SFI1gYe7DNRB3LLvBZ4zKwhbiaQ2wdS4K0o4P1OAXdHq2Jp2XcG0jFERdI677v3uUcVEAuQ7GLVHoVKLpdj6+6IbWnh6j5WxVBLaXY2wLMC+dU60M2F1F19ixDEHNb2TUU7f5WIQuJH0N1u+lM3cDjba5cRQuMXDzlaHEwl8XjmHRGC1nwCdTtiNNAbmRe9sX8myXtbnYG0MgUcLkzd0YjVNQXv5jmmvvrRR80Zj2etTQmLQcOKwFkMScQCT9PJenj8RCm+DeCyT+TpRigxmD/6ztr8lHFzw==',
  }
}
