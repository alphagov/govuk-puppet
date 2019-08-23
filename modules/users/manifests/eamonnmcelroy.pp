# Creates the eamonnmcelroy user
class users::eamonnmcelroy {
  govuk_user { 'eamonnmcelroy':
    fullname => 'Eamonn McElroy',
    email    => 'eamonn.mcelroy@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCytENh+iq+1ERNibPh7gahtZRf34qWfmZ1jNQiaMQQ2+bWS7wgcXe8/CRGiqGI9ib5BjMTEtE+X/j7lm06mIAZ5kEoG1lvH81j6TA/VNP/aNwigI7zQbWeTMuSKlqezKJvT6Mlbr7B1Ipr9X3p0uKp2/oFm/pRaiOHA+psO6Qz5BvqgQKeG4+FkY71CYadjA2KEp2IvKb2yakiI2lxvIx7IwPfTsDb4jooLr3vU4WrPmivXBQL17Mz884aWJBXzHu7rK22fDQh5C+P9hoBPGKx1lPNeDzCEJrLmYNhMpDFY8chhgQ87Vdb527VPeQ/p3wC02g0bRuBbizU5/snDvIoYG8DHY4iEBxDg+tUK8cQV8JL6o19c1gHQ9UfZLgfRx7fs1Qmc36a4ZBSBMP/YoSBNfmH79Z3phk5kMRIXaQ2x6b19UWjYqEDwsnZXAd9QPLQ8YMEXSFhwGIMkedxQw4L57iAabvWfz5kbaviYJnioNu3p7Q/5TV0C3/JqZDgROy7lca9bcHe2RUbgGm2+/JzgAS97mUyB2pIxbhcQ5vxQ8RaxFXJT7xZ9s4JDrXQG+l2fFoWppWmr8kxG4Gf9mVSaMSfFbV9AJgM9TUy4WPxUXARar3R2b5Dg0PNklaKB3qv59x5O+L9/eCig/lT92RbN8Iwpnd0QmERDkvUAsSHKQ== eamonn.mcelroy@digital.cabinet-office.gov.uk',
  }
}
