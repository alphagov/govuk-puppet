# Creates the russellgarner user
class users::russellgarner {
  govuk_user { 'russellgarner':
    fullname => 'Russell Garner',
    email    => 'russell.garner@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8FvNlJDSzkVYxiqeNdnd4eJ+EPdskvtH27wxchOPdglZddWuNY7xIOrgd6wpTYbZp9HHojlbgyBqOca/0v/Lg7RZb5j5KPcgDAy4Dok5csqqTc2Ca5xsVWiNmNVhgRJoNBlljt46xUcdduQiDRB3gTiI7LCvmrRGqfwn0fX6yxp7vUOWBO5lYFphbePIOwj8IdRnev3Aa0aoU8Qkzrokj5nuWW93x5nV//D9tpDulgpMnE7nnxZRWn7aodile4lShSjqb99B04AkgAJwS6/m32B8PltLmeIM0D1pnsJwsbYRPgL4KLdp0Td3YJYVJyQEFI0VJW9ncwZIthqOInQ4nOS9TewortgIPJR95n7PRLiJqRQIitPNnG9fd1R/TGO6RwsesGPXGPCHhIwYW7hKW+IiGC0JODEsls7s0i53V3rkyFLx7aO78nyiGQlJv5iJtJtswB2+Pj7LiXg3L0B7Y2HknrqT3SvdnCl3zrsG3ONVHpVB3SjVtyb/3ldAxJWuQU70X84Fck1Ic22RBaqU6mxu3SGetVWCQvFIvq0VRbqB6EW4bxV5RD41IKCcburVxhT7aDJsyge/39eNStshgkWK/IhL20vbvKLomcxmUliWDaf9SeZci2/85PZQBx/NEzPi84jeBjlqUwYyD3nBsBGywwVhbDd4h4W9N/SQr2Q== rgarner@zephyros-systems.co.uk',
  }
}
