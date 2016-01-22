# Creates the leelongmore user
class users::leelongmore {
  govuk_user { 'leelongmore':
    fullname => 'Lee Longmore',
    email    => 'lee.longmore@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdIpPIrJNN9ZfhiXeTinWB1uHFzVM18cVRBazlTg7P8+kJVReHUfrHmLRIFZGuCXSp1ZCXo4hvOZ4Xlt1kJYIiP4LVrq7w5VECUHVr8s9FyzjszHT8h7+ExiltFfgpnXjymnssQ8tKZk+31+nGNHVICx8gtTv7HHgh9MEZrufneBQOc1OzqsG71lZTqyDCqDYLW83qMR5Kr+JfRXNTn9tKbzXzbheyyw8fK/rX4uaGg/dW4bMT9WuHkzgonjFXTxVLxgCLrvj9gM6fZJCqlcARj5Cjj7uEWe9a1uqA5WdhcfxpUS4NKKckvnd+KJQzeRQ6AUBWTZyZ0grbDILt8RmF lee@turkeyred.co.uk',
  }
}
