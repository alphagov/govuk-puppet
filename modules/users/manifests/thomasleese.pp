# Creates the thomasleese user
class users::thomasleese {
  govuk_user { 'thomasleese':
    fullname => 'Thomas Leese',
    email    => 'thomas.leese@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCsFqOid5M3C4r4pqJOSF27LphXyGaVjRMVT6UWSi7VayzI6IaJRn4RsBq1A9fd/aXKySimAFGzEEx6sFBV/uU0b/jPDLZxk406wDjsAQc2nBhUR1eahsvkHCLJZzdcWEpqOgxQ+hzewRPLYBBmrd6PrzJOia3ieN/tkw8E1pAc9vmlQNavwx+1QPLHAY1DEtT6muTuOkfnfMJj6Z1o9y2/ZF/nSiu3g8gR1mgEK50xAhHlQ5lWc98GamZIQTRqd2fgbAN5d/bBH3f2m/UXCRL6S4ZLgpjsqzVO/84iG35iOXHI4hpL5w2Vr5ciaWGSDFDzMR8W/A/aNQLkyOWmltbvzo+3lmd+vwTbVAlIyHfMzxt9BYiCNMYxyk08J/3E+1W9+7RaniG103mup1UVllR0W32pZFYgvptwHIsVRPyS6kRbcyOKw4EXMY3RDV4cLXrA2WTKQaX1mr8iPDA3zYRiqs5Nc07yRPVWcFVZmS/IiMMf5uMUVsdA8PLxWpOM+P/quJkpJNHFsCwI4sG5xXlhne3gmr+HhbeYVf6jPcnRyqQ0/+SqoitafEP5ssEtRUZ0sKLIXO73HAzZrmxLZt2AhO1md1+RweNpbL6jt3aIaYaffV2hvpXo1Cd5V331Gx2yLODqRCceUjZP9Dg03zvIqewC0yD7u+/39qoPd6uNRw== thomas.leese@digital.cabinetoffice.gov.uk',
  }
}
