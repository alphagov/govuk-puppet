# Creates the jackscotti user
class users::jackscotti {
  govuk_user { 'jackscotti':
    fullname => 'Jacopo Scotti',
    email    => 'jack.scotti@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDgvmRKKUOXhp8A3f8ngWawFUguwL1XkR7jm3I08KiBjqr6EPd7p/YudGT1kh++q1ko26LsCNFhnCERwbmtc1w3AT39QZeDqKUiJlb1rPaJOm0yJTwVaGABjsNsXujrjnZitrGkeqG0BeeI500LFBNOYNiFu0d7BMGgKyPXG1/mZ2yy+GQzKaqys/PksvklrFK5XZ9FDVDperpy/UwNhDp8ATb9Sh581GEpjXVqhEIyE1KCwn+tdLxQZcMVtiaNrtKcXY1ZW+CglOcZ29RVLe63rS1M2x282ZaboQ6IBznhoZn5tOd91uO7YEvNtHXRiQ0TvjCyiVHMTflR4IkGAlY53ANsDMqvN8JEqKqQCbob1RLxNpRPhbeZag4ItPr+OBRWW4weJJ2jLg2hH/2e+tDxmVBub4C+DdeweuCeqeDEmEA2c9NSaCa6IBWrvbXHo3GKkssc0nHsernrGGXW7WVAD5B7pY3+05r641HxV3vggO1FOjRiaij8lCsE/CK0jsPiyeVle7F198fCO6K7xB8dV7rWciroqKV84eSUQn9qsZ1al1Fm4M4D/JhOdDgblfYrsomHe8a9HIH9G5VcGZ6VMBtNXZfZnZwvvpqvEwleiVbLg6VNSJPcKJN7lVVKWUgVyFoBz1KN4Pd9zkTeTBSFscEZUkmy+qAvBq4lHWsjew== jack.scotti@digital.cabinet-office.gov.uk',
  }
}
