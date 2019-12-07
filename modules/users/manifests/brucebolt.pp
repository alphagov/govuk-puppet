# Create the brucebolt user
class users::brucebolt {
  govuk_user { 'brucebolt':
    ensure   => absent,
    fullname => 'Bruce Bolt',
    email    => 'bruce.bolt@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDmBUYveTxVDAWNU+53KVjx/woc/4q78PQTf09eKjZCJHzdw8JJxwFTExeUjjt52pfJYtXiy2zDEcBtJ7rFcJcNaJSYLrkDR51FzrpqNHgnp3EwqyW57/lvf8/zIHvQJcC4bITJBSMoVBZ5QZzP9xu3x1OowQdBB0EUCkiDCvbrEfkz7Th4ToSkiMuhRVXi3y50D+Zr3kALZ+SuhbP13ANGjQdAlQISVe4HZyq9KTO8onc8Fy0U7rUFzRlbxpBTq5f071l4XJSlc46dMTx0gd8TZ5EBhrQjfX2+MuVbXZFOd4TiCSst0vkRQU5SoXksn0uvuN0oCgUj20tupi19tOsGXpUTAYtmuJY1sVTJzpLRSINekMJGd+QFTaVs6GUa+Q9pqTnIK881Df76xAKgyUh3HBBQDTbvpbkLJCTNkS9EuzW5P2YIPGifC8RiT3HCGjBhZfp6dM4lcQ6NksijT3U0uLRjTiCUn/nGIzc4GubCn7EekvPsEE+mSLpwwvsRs9aIwEgpZUfC850ncDW8ZZdoCYv9IF43ZEX9zxIvDibWlMWofErqwNR9cx62KmgPzZSjBG1kAwlK8GDH2g+pJOccLtIilBODFkPVLnzUezHr41MdrXZ2EP/eKHb1L0Hi833xlDGJhMXXbTYtGdiTFnuTNmaxtG70aFiS5evv/NN1jQ== bruce.bolt@digital.cabinet-office.gov.uk',
    ],
  }
}
