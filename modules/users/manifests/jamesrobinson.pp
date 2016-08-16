# Creates the jamesrobinson user
class users::jamesrobinson {
  govuk_user { 'jamesrobinson':
    fullname => 'James Robinson',
    email    => 'james.robinson@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCa0jYGT5np53upPknrW5U0OTuOXAabp3eEzvGfaVe1TliMEQeDPGKpPvEq4VvEHZwozcJXEDCM8d+nSLN77RW4k2G2voRV4ctP1l6B5+6idRm2FSmoaQEbn0i+fVG8ICVIJbY16+zkMFOtViBcbljWzl0JF7xy2XiJvoihKqxdexwTuaylfVdIN+oU/nBrLphyHcG5I4VMAN/D/vZHeWsW06P4FNzn9cXzy0Cz9pngfkF+Ke09HnZ48wL6aLtsAwHZWz5KykJjgGksQGOvYjvCVLmob//9FvjW/smQBRGUZmQB1cjPJ5Ac89vnwT5/NE6QNIfYdTqfQxMvruI4hsg3WxBIhCroE5n1hx3IdA79p3/aHGOIojJHLhMAdURZWcX0shmrs9BnfJ+tVDeS0FacMvrrk8IAOsb+Q9IhafrqBp6PEZSZuPgC/I65uEBIVomoIzdulHMe6eQPTqffSPSYpTHi2uLyUzxWBWaRjdaWdkFxanOhj+yi05ZLIJNclW9MNbg86Qn+kDc9qtZgoVf0VkgXxthviTeznMD/uWn7JvIVAhVRh98f8fTu+6+ztbbwtzKj40xrcrp9HRMX4HNO6tffXGBlUT11hlVDQGBgukCLpDdwfS7t8oAxRt7qETXTKstOv02fWSBSA6pSiSJMki7+LtgkYT4SSTYRBB26jQ== jamesrobinson@gds3920.local',
    ],
  }
}
