# Creates the timothymower user
class users::timothymower {
  govuk::user { 'timothymower':
    fullname => 'Timothy Mower',
    email    => 'timothy.mower@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLOQtMdIpjzTbSRYdFTvDOrCTYeS1N4NS+/hYP0BLoJTPXwYeIr8t1W2f1C7nS/CvUDF0n3rocmunjcGSa+9ZNUQbcEPjVngXs4xPbGTZMbaDMSXk2ov1cl1XG4t/kqkohXhNeYOTMOxzw7V7wfZSW72eIc/1a+cSbquUHULyN1MZRxrcBDqicyf/LVCHNuJklm1QIRxtrv7JaJSPHA03iXUT36QI8btGRxjJSikWjnN7Z9BKG0srNlK6ZPrTSD/8z0WGXfAUqhQU8G2aMOiJBAKWzGDYnLphWb1fLX1d/vWIAWiWO8aaaH+3AGRWGpnbw0uZ+CV4WbuDUwUBfiuhd',
  }
}
