# Creates the chrisroos user
class users::chrisroos {
  govuk_user { 'chrisroos':
    fullname => 'Chris Roos',
    email    => 'chris.roos@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGdEuZ4PdM+Ns/aMZOxgYx5kvZa+a+Nq6wa488sTsLJkH8pkfdIwffxaHJyY1woIICQq5L7i8jVwZX+dBDr4L9tjJdzOWMjmuvy2nWUAgkoliH6pqvSj78HAu3x3Mt+/fbZwS0tNk2tem3884s5WyDxY22+SuUG0vH6W8bpJeTLzvL4RAQW+WiWK4JtUzig8Z+vKpDFBc7/009uCqGNdJ8Tbx2vm6sX9YE4eGK0+IgCj2bjK9xzw4bXuLqq1yzpJ058oUicWDLHE1j1LJYWGEFTnfuz3UjJr1KLwi4bzkZ06TtUE9ryr1Yh4tajRaImzTrylAnpkNLS4175U7sVKkk4z6nuoCVkd8V2WtYnR/JRHrO+eaxMKClraxvEVC/LJAfOtXyOOA+IfCmSGS+O+THHdhjWDGB9ZcbzYQmgHr6Sc9C1arlWCIQvcoWp+mEyFAXauCoNB/tlDwZxOP9tkrAoK3zFoOPsbnKkY6tkG53dDXOSE3JZ0LuzLcGTO52ODyW2DGzdhBg2EqXRR3wmLD86APSD2unriIPMJ6mcmAJw07VsEdZpKDHr2V7Pl/71y2UzCVgMxiETyW6MX6W/bFyDwR+s1zitdy3bAQ9PvTNPgdkxTUEfFyH99f5G9J3PNs/5amVfh7j23/nKp9AzhKVH5hK1JapzGPbfyNCwJZncQ== chris@seagul.co.uk',
  }
}
