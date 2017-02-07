# Creates the elenatanasoiu user
class users::elenatanasoiu {
  govuk_user { 'elenatanasoiu':
    fullname => 'Elena Tanasoiu',
    email    => 'elena.tanasoiu@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDZMKecJ9nQ0ONY51hxFgL+303JT3vStDze7DG0Nmy7qlN3SS3lrXk7M4PFp+pi/Xy8+4nF2PSUJWNXTRxgsqCQ2bYNT+v1zVHaJI78QhSxVvrsB7qKW2/5miGrQkFGAlUNEWKlrduyAaDVEiRsapIRHqeSEBta97pe24CIy394ypIkhPwyaZwJeFOYR6kuI+PgjPfgOrTz2VnQABymSnvJ6/0bTMBOyZXT4Zx1SbmUNQ8EpMvVLfSDh1LMFRLjK7beAQM8See9VXkb26QyHEvaVkR01CLd+2JnjdYllvj/RnP9/UKn+/mOmKzcw61/5afs+LacujbrfWBIa3WBeERkEdA6XhEO5Yf2n8fkPB935Vhgykk/0OdPXbzcgvAA2ml9/hbmt8fIP2FICsPP7cwNprnrggswu5nRtodtjT5FcUD7Xsr9OdJKpqykqVu9Crlu0iwWMKpHDPHlJDQb79pBj3xI+Mk5NiN99sgLMFR8kLfx3x5mwn5yBiKHgHR9LCM5wt5z/w7glkxbyDo7LW3bGp1fiIPY5eAVcXieMeghZd+dkkLAfKsosoLNULb7aZvDpDoxyQ1QnWbBePe65HFMPiWajeDveKsFSlg3x011RBJJUld7UXPw/XlxqSvKKrDawWZHmS4J4qlumYq9EJnyIMPcMMCMIxWD3yfR6a9rmw== elena.tanasoiu@gmail.com',
  }
}
