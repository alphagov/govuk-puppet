# Creates the chrislowis user
class users::chrislowis {
  govuk_user { 'chrislowis':
    fullname => 'Chris Lowis',
    email    => 'chris.lowis@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAQYkVIrdmFszqkC3jsWxAUbuiSYtRUAfSWvH7KdYetxe5kS60pIHzhjfhpJ0M5EYQrjMLrfc9L1ORGrbcQH35bkBd/135ufxZJ5mWP+p+h771tIdPvJ80SMg6hJwkAYn7H2ZIsDe2txa4kF6KzExa2pF9Dg4lyCOU2BeJjD41eFcGRPzEWTDfEKXcjdUIC7toQyfDfsrc8pQlfgAgMmnUdJz3IxeZDHTkWT7PZoVREXVZiJD05pqFdQhk4e/dylv7kqfHy288jwBuYF8IFjPLspXAoCy/OGPIpje68p6c8VU4bs8aixpfA20yj26g1otq3Enc8lTytLg4IKcVHK/qtOMbI8tfivFctDxK/eaDi9m48T6j38Ix+Jn6W3hrzjYBZ6tTRF+hsUPxs2R+yiMxo/DMMqt1DvUSilej94tZwpZ5X7h799qbWJZbYBJ9kg4YRyI9ZcHRRzkS6E9wQvLVAjjZpnzdhBhARF/ch2XCFdZFN4VzhWZtyhm3SJrcxY7fCBjtCEfTdwi0MsnfJ4UEb6nawUCCu10U0VSx+VXIz4JpxTFs58hJbMccgsku/n0hokLiYYhFZC8GEfYDDFL5Non8u8liVBRRHtHp/bkkq2pv9bK1Iut8ukZeufEccDLPMCZLALXva2LFLObU/NCJwdRc0K+U6CXM3Rllao8u+w== chrislowis@munro.local',
  }
}
