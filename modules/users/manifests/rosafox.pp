# Creates rosafox user
class users::rosafox {
  govuk_user { 'rosafox':
    fullname => 'Rosa Fox',
    email    => 'rosa.fox@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDc4WFKxhyxLItpYixyf/0o0Cou3/mW/Ktd5y0ij7QqLX5A/b+poJXc+6zwM4XbJAz8mcvWi9wsMlv5j9yjSa9n3MQsM/ZMfw5pNAujeP7/+TgTISAAJt7hRmtWvRu6sS/5EsITCTPkEIDDLKfuSvSy0gou+zetp22GW/PgnK0xaykgLWPGGXhEFVm+6bOBFq2vGZUYn3bgbSQZzozWGT1tVZePwTceX3KLOTOkis6chCv5UHh1a5YE9upfZym6IDCgKBkRA+Wv4vatbXy/ULDoSFzgT72unNdddu6kjixy+E7KpWPPqQjEDc8Bmel1gXr52sbg1+Xacj7LjKbGnvzyFmdPAZXMtQTu14zsIx9Z4F3Sha8qP05XkXANvzHmhGn3XuoSa4fARqngrnSAvuGILytd8m8jGtM3TfDJueJJ2EX5I6YBUiDeJPnKzh3MZXJFh3niCee+lupUGON8Wo/JrUsw+Hs/kMPeIu20eEynm+m5OdHwGb39arB8YAdWHTxumBG1rsn60GpXGAdD+b41ghzZr32U73m2fuXnRjTMrTj2L6gJZRfxdoELCE2OfixdABMT51V0LbSnvXc/uGIoRx6qqas3LRXFdAwqTF7foR+k6GGtQYSiSp6e+/rZGGEGOKIXJdDTYjxc4neFdNRLP3UiV1ys0B3iWw2Sgrwu/Q== rosafox89@gmail.com',
  }
}
