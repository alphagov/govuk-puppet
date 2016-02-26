# Creates the matteograssotti user
class users::matteograssotti {
  govuk_user { 'matteograssotti':
    fullname => 'Matteo Grassotti',
    email    => 'matteo.grassotti@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDK1I5i8LSaOF/P1fo4z/e91AUlISLW7E0i2mHiA5L0fP6tNgL0DSnaIXfxApwLBG3fQr10qoeGd3NCoOVDskfpHufVyR383V5TKpYuzUrOy5IP4Gyx1JOE+UhQwa+NX76zqXYLETa6yc4nj0V6I+UbmxIXlNI2MT70+MCATkw94tN6g8YS+OTvZAy05WvnetFB3TmUqbZ0X89lFBY5y2HHmJCdsxRUDFrt1M1oSbfE4sWNr9wLlgAJth0Lk9J/YWiXs3+K9vtzNOUfxikvFdnHEB+AXswg7Go8FwGUDzNnMBoxFqx2GV9+O8sWn/knhKpwMx1y8chvRi+SDIFJn6OMX8WUX2HKsc3GXHrhhvGhOcKe9AtM7asPCjB52NxVm2NobkN2uSWVFjDLQJR+Z+VTcga4LgU2SxgBYmpFXNTuNRxbOM73dbEEy5zL+VBDFLYHgtNhJFk7YHCwju1dLjR8Yyy4za+Gw2Xb/1HxuWp6WNZCVfcyB/7XBTEvE2ijr3cwYBcUa5nsTrYRz5uvyEAfShKd19FQbPSeJPE/j8CSWj2S0m31k+ijfioCqJ7bhRyRnEzaVyltasYrXH2qT2x3uDMs5/NUz5RotOzTEAyDH/Oz0QQaWG6YYCVReQlEVHm0tdIXCX/JcSi9oJcl7y1rNzd6CNbi9OLwjojiQ4CA9Q== mackeyfordev',
  }
}
