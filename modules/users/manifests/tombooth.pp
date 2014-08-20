# Creates the tombooth user
class users::tombooth {
  govuk::user { 'tombooth':
    fullname => 'Tom Booth',
    email    => 'tom.booth@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNY4EOtJ+6Soa5161UXp3gb83FFEAGf6HIHAwjPCNQ1ivV6ErADW/nc8MGwNswlLsAszdRYkJTb9KQf+TTgqDq5suv5QdAd/H+gTk8sfxMJ6w2Phu9ru7WGIg7BnSGm/WKFtj3uoFRbaRrfAjsXMQUIZ24uuOq4OsjJi3iXerLbOaQm1BjqxFR+CYksdzzI73Kh+quHj8fELey1jvxPtos6zVK7tEJegxJBJPefs6qxG0RgHnQ4uzG9Ual/LITy5mRpNC6TpBMN0GC0SN207Zb84pLTS5aCquy6x3dAvWpINoeeIwgf+PhHXRZU1jCmpWk4lVqMI9NELfQI5u5ZoIR tomhbooth@gmail.com',
  }
}
