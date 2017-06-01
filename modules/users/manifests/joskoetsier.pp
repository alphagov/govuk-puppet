# Creates joskoetsier user
class users::joskoetsier {
  govuk_user { 'joskoetsier':
    fullname => 'Jos Koetsier',
    email    => 'george.koetsier@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQCez2XfC5Mh7RC88jtbMFsBjYeE2ob4y7qeuwmf2L6hxB1puTAnNfyZkVBodKIrG/jgC+CLX8MKSllF9+VrIK47iawcFAztj62DbAqqnAv5AcXUGSO1hPrf2iC0u4c/KA9mHYkaGimuYOe1+QHID6Rv185Yrv1vV7ximfqkiUFTq2shv0DbwnuhiyYQ8CVeqqrXvbz3xX50FFIIyp5QdaR0CnyFuPb3TE95OpzqswpNmq4X5VbtynL7b2ObxQQ1pAemfnizman4cZZDJsaPSlWu1t2jmb6Kmzy+crGiuhRHUMWcazkSeT6l+1d4X6pddfLXLhIvAI0WyK/05Fq9ohR7WQS71zYoC6XanLaLRRk3NT18zj+vZuKYiydwNFxQ4CgGmoSyqkQvyieEF7kQhHDL70VASvQ4dWn5LrDcMsy33XQFR8nvHT0NO/ahGeb7QOg5e1KgoyELQjNpVDI5OTBRh7RR0oONl5Bi8WgfKbxaDtLqCTA21bu+cxzYZuIJqBCVA37Oer+/Sp3vwK2zaCDERJZMSBP7ynAJL4mTvJG0jMhfCG9kDB/N0vg1dP033nFqJRpNGIumfwm2+g6EbK5Tgjmhg+m76cvSilMnJKVIgHNVDRrDRGILCI0aw1I3knQpWSDZTfeHFRPOfc3kVCB49iUEe5RrbQGpIn42U4R/Hw== george.koetsier@digital.cabinet-office.gov.uk'
  }
}
