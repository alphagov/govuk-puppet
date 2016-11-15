# Creates the andreagrandi user
class users::andreagrandi {
  govuk_user { 'andreagrandi':
    fullname => 'Andrea Grandi',
    email    => 'andrea.grandi@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAnaiLqNX9WrACnLsZl5RHwWQidJD75rAPbtEDDHg47GuMti9yu5EGUu/68DWGfNUhAC3FS0tGVxVlqMSSnzsji8JMnoHZVYqK00w5lmNwuaBZu9iKkKgHeOhWXKfWhZDA/blkQc8Stc1Vrh+YlZNlJ/tiAORxg8Dp4mc+WXI1H9MmKOl+DjLXt5Wxkl82D7zO2fFBHqlVT44zTBB/DU6KWnOc6VJ6lKFQiCyChcZKVfHPXGK6TbasIcs4vrtP7k1LLf1uz4t6DUnkG5i21ltpD/Jm41WJm/Gw0ryzWXMMaoK7yn0T1BgGrGMYWOA6y0SD/vB5MIQd0iLVaj1SFHPu3PkS5lCm9VkMP0H1REY35QBSiE8ZnhTvxCzW3yGs4wb9rhb3F97Uj7fOmbBgwvSWDTH3CTIYFCUw59dUahoJbraB9CUPSa6BJ29qJo40u7w7yba2oeGRb5PnM99ae/bI1a99O8Gbee9wyMZdaGZUBQrxsyTjh1Qz8VcL38EkBm6oneNzThbtP+4IHmkFHSEpsP5nZ4Mr3CcmLX7E2/MU8lkJjot4JOK49axK7hX2Nbek3VhR2giySwUJv1J3654q79iDCObGGL/iMBBJE17FIrErf6qnpnrw27sA3U0BL7TYAWDSAkuojmjCuNn2AlyMSkw3BH49OGRGYd0y0XDzhQ== andrea.grandi@digital.cabinet-office.gov.uk',
  }
}
