# Creates the paulbowsher user
class users::paulbowsher {
  govuk_user { 'paulbowsher':
    fullname => 'Paul Bowsher',
    email    => 'paul.bowsher@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGc7mCKEuZH4fcqos9up5oRGa3n5Jl/xSiZ+zVKhIpgZXQ8M62QUqA1GReJ5GgZojx2BlIJAj3A7x9QxsrkGCkeS7Mc5gr+P/VHeOXJ3Lnbcijaunjf4bt4DszAQLjamGZAffceRUL+3C1jeyPfj4S79tkajXFySF/E035NK2v1qqeNjP5p72bZGlzzdFVuJ6M5j+CSw3bZqg7pk63CD0bnEClYD3LVaPOhISj2vuHSNFv6yiJGDBNYXifsOtwxj3hMR2NiOuucZozzKFcrSUzsRzu2E4Lvp2tXpSkSTK7C7dWZM+PUpmDbIZCmyqJ0btFNrrS8OditqzvD0aVtgoPyZXNVzeKX/tMcOfqi4GrvdweG6BSRCbQ7oncAMGmk4RNqvMrO1qxIlaeofb8ADcVSywoYP1Hb9sbbYCpwW/5sk2VOBYjyj50ywQr+xy1DwVEz4vVWH4fYgv4Fz2iBEYe9d1HmDEG7zPo1HSverEbUZDl7oHP5mDxJxmoyRWTOpRlfAQ51y/zZt8pg6tdVBodDCE+whCmruzJzPwWYLxsK5538Pg9r+DREQt+E5MH4D/Z7hd1ekT3ZUR4jS1XfRXGgpRml5IVJQSwqZWKrVkoSlCfyPzdwCLHSBHm6SJo2H9p7secdEc60FoSlwNGX8ISKonpdR8TU9/+LR2r6FuY6Q== paul.bowsher@gmail.com',
  }
}
