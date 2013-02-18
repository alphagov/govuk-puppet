# == Class: users::groups::govuk
#
# Install and configure SSH access for GDS staff and contractors
#
class users::groups::govuk {

  ###################################################################
  #                                                                 #
  # When adding yourself to this list, please ensure that the list  #
  # remains sorted alphabetically by username.                      #
  #                                                                 #
  ###################################################################

  govuk::user { 'aaronkeogh':
    fullname => 'Aaron Keogh',
    email    => 'aaron.keogh@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC7HA9e91WlSQtjKdRqIsE3SFjG4nbBE5W1LwdmUfMbsm8TFli1foREvx7tHtClSC/KQtec2BrtmCKxwApN/LZAEPR7gRyOe3c3FWA55ZygPVvCcJyzePS/e0DVN5NqTuQO4IYFfqOHJmxyJTZ+Tgub8x9YYlsRPud9mvckb4sRe1ydTSJuDDqBcfDKcPyw0xNCbP50QbhVpdr7H6XqbShyIQogN5O9NTvHySBpSbgqEcog7zOJz/zWCc5heXcAo+EYbas8HIaQhlgmmWprbIxJ8LGB5povYnP3WMWs0GN2mw/axDLRxcjN1czDZdCeqAawuFovqtE1foGLjr3mHz3n',
  }
  govuk::user { 'alex_tea':
    fullname => 'Alex Torrance',
    email    => 'alex.torrance@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAvVHLnQhI630yoVvhk86+yPPBP94EXsjgS6eZ5gsP+gz0+INp0a0jpNqMkpbnXUk2VHG3KBIzVhFnmR6RiMSzsZyVkAcPuCAFDX/rtr6zZYQ01N/8cftAk2LrkIzDrRuPn9qamFLUr7iFqzgZHIFCr2TagAB2uNIo+FQKsnXRD7nD57ipgJ+1lK1eYuOSnPeQAnk+2XjIIKPoo2hPlYwEYOb+1dhj1FVOHPgm13oL9YSdczWQyEMYcvQQp9U52UZyDfJ2In/eNHDUIuhkXVJoXZwel5uSCGhv+4qXP5PtFHv5KMFFTT4g/FiFYu3W+Nl7QVe2y2zz2GZAkBYcCxDUTQ==',
  }
  govuk::user { 'alext':
    fullname => 'Alex Tomlins',
    email    => 'alex.tomlins@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDEgfmhnlrUBF5i39bRssSJDaPvSxOn+cGUv2W+nliyExgbzxjIjE/qsbzPONyp1S1eBj2//EdLXR0ywzafNtLYG20dETF4RYGrULzww7RdX9KoJoLcujQy/T2+EbjcbuA+WXe9NLARSod3Sba+udFxV9uoVcVvHl659aVIKOe0I4iiu14XySn46NEXwmoL904bdqqc4FyBAYD1ch0uk2O5233TEwC32tQ4EENLTRsClYIGy2Pnq0h0gI8F031JMSuzYuum9CR4F1BkrrOJ+t7RJAy6rp8wuSrZM9Y6VLwMRHDbGStq3mNBZK4f7ZsIcaJwaCv2rtLYoZEmEjSQNVeP',
  }
  govuk::user { 'annashipman':
    fullname => 'Anna Shipman',
    email    => 'anna.shipman@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDAuPt8UVjsxrbNUxy1v+Rmu+hq4bMAa7YAgAgyAuNrDq1G++RzLntZMiAELXWaxOrGNk738d6qpi/rMIyAY9l87woaA2/WRhFExkx2U5nnvLNItkxPKiOYHi1+LmQ++swb5zcg1P+TvkLPeNm95G61G1MxzEuROv/vAlk8IPPPWp08Qg+3vby7P0zyeu7KT8uwfSEIcXPxkofeMRXPiD4DSudYACEV5DB15YX37mlqu26QqyarTVCUMSvu916ejDSMeL/uE0aNYVAYSLmEbtat1MX0rZsnL+Z3F4UqkR6lmYHrK6++ZjeJ/TXAECdfH4uqdJlgfjXkQedg/LQFc9ZH',
  }
govuk::user { 'bansalp':
    fullname => 'Pramod Bansal',
    email    => 'pramod.bansal@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDw2XKGyQT7Ki+f8LHsWI7Aq6gixCEsv0pu4uRUzXCXbT026nRA0+/CTQ1SdvTZQMja55RKJVd0obzFcv4hinPyz0uuJPGdyxYxqUXahRKOV9LzpwDY3FYzUf5wA0Dv9UBo9UKbvGgmBrNmwmNCxvchLGO0a7ZSA5rAHANcSYuc2BJL27i+P4/0DUQa+YPB4KzDuhbAI5dXXPVPkw+wguQ3ZOqlly5aShWIBB1hDiKkiLKa/WA7G44mX4W13m3ZDbNDLBvw/DiI4y1rOmFb93k5U4cuNfC+Xdgon7XAzwVsKDgX1V8fyCBNxCPbLW6MtpsFPhIWiOLZubQtUXSab6Bt',
  }
govuk::user { 'benilovj':
    fullname => 'Jake Benilov',
    email    => 'jake.benilov@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEArCY6wWXNDgQnanfWtGs0wRVzHcBApLyJ5MWVGVZL+aLbRlgoNj2vqaGTNCXkWHbfpRZ1BRNCuLhuF0xMNI17nsj2qaUohXqbOsYAyycZ3GSE5n5fkrflOrk8bAsfavr8WjZq2tGHniGYol+bQYw61+RzSjKQ0GX+KSVzQ/sdKiUPnIG7MoZ0PA58CSxbPhd1OLOMa8YR5aK/7ildABcYqMV8Pbr1hVyJ7DIkJMpt9PwoFVketzBdIUo/fqNez3LMxwNnijlcIfhHrlkCvLQgeC92oinEFfRKcLFWPy3k6Z/u0UddG67XAiZvfDdZu7NxrOw2mE5keiHWrKaoIBIlZw==',
  }
  govuk::user { 'bob':
    fullname => 'bob walker',
    email    => 'bob.walker@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDEh7U1DlU9H1sWzzpuld/ifHPGTNJkawI/5UJmLWkZjkTbwtIMyoFi5QWtkloKVEQQCjCIHwW5+hgVzZmD63uXBYhQBJmQ2wuTlcyTIUhOtZ6RW8/nYmZm/Ty0hi1iYYKUrZRZFTxpt38VMk1VNEwYQ9BBK00GsJkExKktJLmGsmmC1wfoQrsl9bYwwkvenD9RreMVAO80pnPrvYxy9eJpXY3nC+MT7zIOLiN9XQ2BpBpGH5dLw2P/zRENDxv48GCz6bllTO21q5iRMgwwSfGh65mANHXDsHQgau/BnmSulFlcOczG5dhscT6GGG8yx2i9iiWuySbV2BfiuWjTzzq3',
  }
  govuk::user { 'bradleyw':
    fullname => 'Bradley Wright',
    email    => 'bradley.wright@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDlpKXpNLybMHgL42W8AemrbBuD/QWiblRACI+guwSrmLuHery53Dx1Tp8NFaMHXTPnhm0VDlvLO7V2s/hLgzc10ozo5m8DQR3ziAcG67sicTjJCdA9ioOPCphzhtiCAMP39Dn/7dr5/XSHkmIvVcruZqXifklRSzkTjQG/i6Q0P3o8ueU/VAOyC1sUqk1DXDt7HRcahQVgisYxaBvxbjFd6CgrrMVchmzWlR6jLY1+Pp1Ld/U0z2/37vuPOYhOimaSyye2GtX2/e7huUOn2gRiH8KJuASFojvmmg3/W4E5XIDcHibXD6DMqX5y6gk338rzLTS2FdXPL55XGjG2kXx/QZNDuG9XhTBVTw1E1f3smDdrArvPOKIVO7A98RgPr4dSrnDM4xABAF+L3JYAiew4voytNglxxet1YzMuTHpoW3OCQusVyiuLVFvBjWsaJ3CgkIIg4rZYFkWetCaFQIJ4B64x3kJLGtp0GX+LFhsTvj8giyyo/jHo86OevfitiYiuzh+iPCOUgJMbXNQA0uPeg6z2vuXybTYtBYwDB6TuxE0DzOIhUEEDEt3Ge9o4YPfHGfr6gO/qEjYxBc22UUMA86SSe1K81kIfMQXsK+PEQJiwBWFHveC2ILhCJV+3E/xO56upl010+j15zFMubmMnQGQdPHta4c8+AjUgKUEM2Q==',
  }
  govuk::user { 'carlmassa':
    fullname => 'Carl Massa',
    email    => 'carl.massa@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDVDNaTvxowwdKWfdL8CPMjJ4HtNkGI7GgCWDDgWrCnnfGcIO5flGNUR76ZV9DwnONMU8tYWbu2N3nmTjrkTzfBSsgH73QFqfTEjDMlCT+JnhUhFoHIhCLx30yC6pNSVwO1BRIqmOcc/qp6peisSDjUlyXzYjh/RZm0rhU8dxb3NYsvTZIGQ/UVYb/Nv4NfsrpyC2uj7jmgOo/cp83J39nla0TsAZFHiF9UpW41n5QrSKh2uE4GZvbVLRe3nlgxZH+W8R6oaIQ9wwLzU8CUK04WQlUIZP4/Iv9wlb4icWjpWT4sVk6Um3JuVeARlly7NQKy4byqduym2kQxLF7ftF8L',
  }
  govuk::user { 'chrisheathcote':
    fullname => 'Chris Heathcote',
    email    => 'chris.heathcote@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA9KolxDUqEoD+0CFvQCsUm4PZ/MbD4H8uUVOlgatbPAXVp2bSkvyBbmcodwuYoxmZET+vUC3EYeEWnsZVRFi+nxweOKxBwYDBz67iO/wj/V9WyP6VEhOw/45JNzkGLHKi84IcwYSrS+O2Y7xtFXNKTqiIJFjb+a9XLFwTdS5sMAzXi8Jhw8Yu6X6IU2+Ub+Zj1SYOgdu2MsbHxRFi0iDqCd3MPIGPwznWSMfP5TkqqPlG9cX0+92E8P3I52cSDgej+FEv8gMkX6li2xWUb1f1ruG0YWbmDtyb3BtWHhzhq+UE3C0wleHWVbWcOq+gP7WccZbk6d0HS7wXy1T0ouuktw==',
  }
  govuk::user { 'dabel':
    fullname => 'Dan Abel',
    email    => 'dan.abel@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDWoMjmzyhI3smmKziws6bBgHGf6bp00k2//Tc9l8mDtzBzTJmvSLkb+Zbe/Rmi0BE+sHEANa+K+AsbqRFVFQG+Risx8Mn+e9LVoh3yNKHyBOvXkz/MsV9LECmDpY7tpByb+CWXjsWID/ze7oc85QGXdMWJun0qQOt1pjgCNuEtXyPKT5rbGc7JlJD0VbODtXB2ft2EUEg4l95lcl302fhjZDNXhjPuczhbRXY1B0WUg9uGNmrHdmbdk7Kbcyu9JIlUT93ww+fW1edSiX4BWqGnVyZaLoQr1m1dyvd/wdM9gytfTOLtKUiKgI61nk6Dc9Fz0tGYjmvdIgsk3bqlh/u5',
  }
  govuk::user { 'dafydd':
    fullname => 'Dafydd Vaughan',
    email    => 'dafydd.vaughan@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCzjVSo8Wq4eJbetvwh1NxhY+mxXBCd4PydWVDpUphtG5iLUyco1LNdY7yO89a9ahbhqJCxjD4QmPyaUGWdnUefI29gJyA2Ok9cHl0DaOsh1kqxaV1ETwXG4aYTWaPNaQAGpBoBq3q40n5wuxq9NUq2LLj9xm9TTNoxmQJSdjkngF9ZMFva5EndD27k5ohTKe0jy6gF72llRQMA1bMqCIiEIwRfQBcQZVny3S/ukKqXsIVU/7kyrYPCgnT06orYwD6R/2CrVYINYH0Xsfa+UTL1CY9QdcMYPiKK9M+MFgLQdKNzkVUaTRJYMfHFEW/SbbqliKv8tu68sSTvMGkQIvE5',
  }
  govuk::user { 'dai':
    fullname => 'Dafydd Vaughan',
    email    => 'dafydd.vaughan@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC6PiNMw+35MX5JsLcBAJdEWwL+FARJOBtnsc+MK6KrNxI/xRmtPkB7mGQfVsbYthctGcJj4vy+Xt7mfI4h+FZqajTuSzU3a0mBYkEAyVGNOIJKe49zshewUDIHjJjHdpGI+lpgZxseW2I78S0EjRYA9Uqas63UJTkFXgO35RymHnv3sI8K1MLBYJZvoKxV9GbUZQMELVlwg2BHEVH6OKX1zcQocqaAM8SCS/wNvMqydh0osg/WPUzItq4RLjRi4DoSSL2NJSQuVXILZWnHceWYOsl2wN/vCVMaW3BeQjfhti+vyAm8t7kV6KB4l8G3dXSqSop9qvRXiLO9mYNnI41Z',
  }
  govuk::user { 'davidillsley':
    fullname => 'David Illsley',
    email    => 'david.illsley@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDCclnL4wVXvcxEQIfjT3P04gp1NIFPUHVvfCsKkiNxxNRr2OD6n0tC2qdnqZcnB0/Sz5vr9VHlwW/IkjcgRaWqg09yVZ9p82tec42o1dKcQWeHjFSXruQHKljEoPJf52WX+fGDbeEOd78coWox8d5v32by13cZ2ILqy9NvpOStDsNNBpLALO25kgwteuXrnIF+4W20jmAv74hgYu3M0Gxzkwfb3kvq1MfDl6vOzVuKaNf4uHZ2+BWH5q2y88TLTUObkVq+EAkP5sgyV2RqMUi8kZJ4wXWIbXZ9+eOiYQh2SE42tUnfmZrpZzf5fzyeVgOTGrf8OV4wf0j4Ur2ByLAj',
  }
  govuk::user { 'davidt':
    fullname => 'David Thompson',
    email    => 'david.thompson@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDEovDxQewPlw+vf22JYCGN1Ada+9dCjYKBTkjH2t/miQPo6PWQhiZgLUJ6I65tHQKxb8kGLDIg9pF48vw3ioTZxIdNf/z1VocKG0fG4GRhFI0hNAuMg3pVf7Fj4QkBJRbnhnQVaLPBilche4ITJD0edM+WFuwrKFSFOrBPtB2fJmVeFpCWASM02Oc/2D7V4HTsEanob7tjhy1pKz45a6Koa8eSEh8pmj7AnLh39YPufT13g9hXtiMNOvY17YdAyKoLQe/Nvx8+8+nBPkeJW+C15xI81Ft0f1WOIhEpwc4QLqcTY1PKT7k1s2dD/pcFCFwUchZ1HZbDcgLN4BYd8/0f',
  }
  govuk::user { 'dcarley':
    fullname => 'Dan Carley',
    email    => 'dan.carley@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCd6wN5MjI+l8Ggjf5xhHT44L9LIGDR2dS65ovQcQ9VSTfnP3CMaF25ZyWsJ89Gu5UoO1BEbzkftMzFTjGAdWDFZ81QAl+3GGy2h3iQXtGvCKuC4Bl+OoaOQ0JuHySNXsMT/EyhzNHZN9SDPIOh7d/OERSYgO4RMSXv3SkYdD+18VSK9cztwloJYfs/2J1fYe+O4uGQd3NiGyiDvpIdR+bIn3Ct6T3Q/FgVXwrtbs9jxWw/LKAP6jYtwxdU4a8WcuijUS5oijW3iNKPMXwkxGJAH+J6fFbcAePfoheiehcbpa6dkshRWh2qG2px+T5V3HL7QVm70c2BTb/iA2MZOKop',
  }
  govuk::user { 'eddsowden':
    fullname => 'Edd Sowden',
    email    => 'edd.sowden@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDJdsNz9WXHtrO8NH6OL7QrOZQkzKWwH9fR4UMi+8958IeyHPWpehB7Jifw44WfETxBJqP32Vzm6VS9NpvfQ7b2HiNJXQiWr/zfyyyV6VhA0JB/+61Z16e6+yhPT5eXYZZzYQRXdbv4T231bSCZ9se10yeBaDRpkP/wwKFxL0whhFUQbhmLm+6gtplQQEOe+mJuxW0JeESLYVbL6FxvqRZPe04MXgYB8cuQTVVvhhtCB87V9C2A3Bk+H1cGmI+QLA3lBxQ8CPD1UulyMMWMHoyk6HECKB8CNmK7KcNj40X4LYqoIqBfp0XYWztIPZaac/JCjRfR1LhpMxwH1SmCKHfb',
  }
  govuk::user { 'garethr':
    fullname => 'Gareth Rushgrove',
    email    => 'gareth.rushgrove@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCuJRONJm0HaO+YfY2PnV8vk+v0FuZGxgCliS8wF3RiP/A5qV2jtSwy4KqctLRS2nSCT2klRmVENT2SXzdaCI9CDLIvzX10ePUUhE8PYux5dC/RPPRAGq+pxivdbu4avsc0Zkhq+v0h/og/+7gtwlan8TGYJGBy0UM9h1CWmd072W9Oi5rBDw0tLLMWl6T8CwAuXaU2tq/TW5jeXNVekUgQlUiA4FYFJW3h3G0rkZJ9p4WKU9ER+sRI9UxUBSeRjyjPvSKdFIKlSBlTBStT0f7V3pXvTQFDzaCY+f1VO/JKZr5dHlStKhxZir5tPG140CHApaC5Mg60NseIdOyU5kzp',
  }
  govuk::user { 'garimas':
    fullname => 'Garima Singh',
    email    => 'garima.singh@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCVHp5WGK5UseUbg8Qz7x7geR4RInaM4Zrmd2FeyW23I259otKrqaeRJLzcSaliz4esRCWYopK0q5iTjK4oOSgr4BM36L9B7+YYIDcsG9F7FHoabxoDwrfzWHYhknweQpZ0S78oY0PUcGiwSXT1FUHHOTyMOuYETZ6/BKI58+dwUz/tj2uCG27fXXZozQRxOtUQgYq7afGRpifiDFX6b8z2gjhM6N1wP9WyqL67cuXO6jGaMDDKh8eLbPswOFxcBn/rqjUpVfDVqfBOAbL+6OgpJKdTZQtCYEgW3d78scZ5DZazFGGQqLQ+we8srov2ev4OISPjSHnNxN/rrlSD7j1R',
  }
  govuk::user { 'heathd':
    fullname => 'David Heath',
    email    => 'david.heath@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAu0C17mT+R1TMyAA3E7EUEH38lYsnFqqgtFjJPpC44IL6Nt7AQbhr5FNGwgA/UubyoXPdhP89fvY4pYJ5CHvly1x4w0N2bmDCXCqIbuueTi6pbhj4/z/DbUfxOpLmXJrk7t3LDVAj5mbqN40dDbD+3+jYwjWOAavqUQ0YKoEH63EQV8L6lM2ukC4tF2MVToFqMVrdsMYuk6kXDyEYwpfw8cuwn8sBbnbNerKOpt/OL/i/D4dL97vUn7GL1PM+YVh6vavpxOfwanKCmRtwvncmyPQMY4whJiBBVRawF8WkukbgFsr72Cwnwjkm1JHjLHwRsuKhMU6RB/8JFj1i22+pqQ==',
  }
  govuk::user { 'henryhadlow':
    fullname => 'Henry Hadlow',
    email    => 'henry.hadlow@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDFLyYiA+8aNel58JKdiAdS0nHi5DjiqAb9E5rGmg0R9rAdnqYk6ith9mMhQO9la8A6AOHUy7H5cD+Nu7kjpmvmF1bE+Lps+Dps0uVMunwM6eNqBkG3qDprK6WwIGweLC2MNEhwbiVvjfoRXkUAiicuCAIzaMpC2wNKpFVTDcMBVqoS0439Up5/f0Q/1FLtNlf76V0nyetHR3mt8jgP5FgAnbQK0fG4HMwPp7juEqJkVul0IGuosOMEM6yuNfdTjwrVZ6wu450V4LfrzfQ3Xbc0nDfrb2s9iBrtVzVsWbBef5QviY6ydRjHa8qR46zvBs3ITz/3MxvWFbgunLSB3hTz',
  }
  govuk::user { 'jabley':
    fullname => 'James Abley',
    email    => 'james.abley@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC2568vUQp+Fb7bmSML5OHn0N8gmOjQp9LSE/HPh+xybMiX6ql8JhxDhPGl2NZl2zVmhICLlhY9HcX4E1w2mHY2MgSsoE148QPomYmcjkIkcQxh6nFN4Ga++foTu6WPkUQJudah3ML/XNs/D+yMgxk8nkel6EvIqgbbswlTQp22FmqGfk9XzJqX0mfTrlggJlacYlw+Z4JT4NhoFX4EefSSX0c6qm7fipX2U7M3hJUXxsakj0jM5GOk9xrEVCRUgx5M8l3rS2DwF0W54RewAdq5J9KdnIQi5DOsbVJKnR1flpoaIVuRq1x/feZ4yqi53ctYX5MT8tb6CLc8zmuU7XyR',
  }
  govuk::user { 'james':
    fullname => 'James Stewart',
    email    => 'james.stewart@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAqwZNyosGZJ4L5mU+jisfTMk+jU0rhhgfTLTRut6TQ/hvktRn5g70xSVZKUMLdxoxjxgYS+630TY3N9wimYzCuRJLLHM7Ieih+emM5SCrXeWLND2k2gxReTxIAv4qHHIEJLLTbywUMeKBBdHA7UXTDOI9j1k6bR6myQT60Iwh0bknL8tH3yLP/SWUcI82Lu6QNSnT3epEXjurKbdz1RvUW+bN1CFO9ARDnBZ001/MIOge2Q44RHWrGz/bvtD9guyXzK5s6HVQNzbApinUqvTby9gbuRtT0OBk6T01wAcXvmMLmp1+mKRmkrlBhTgW00xijeU3nH2eR+NeSrTrRDgWmQ==',
  }
  govuk::user { 'jamiec':
    fullname => 'Jamie Cobbett',
    email    => 'jamie.cobbett@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCocQlnao2aVxfTTz3LVI0DSezz8CiMl6Ewphky/D25+H9PbC9GiD95/kLw6+2AVaJ7eGS1xKCq5BKzfNT8hPSVKnIIkGgUf44BWFM3G1Y2GCQ3FDDVOTv0i7CJt3CZJ06oDkLyyXmt86J2kjQfFnSvzWKmI36OiGr7QFez61G7k+6SE/ZmDqZVeAs+qqmFG+X0HcRTsjt7/u38xWNqofNEJfRGfPnxo3Jemy0IKlp0a46Km57vHHsEpTe/iUQu9koA5mR5eyW2hoya/Y167DiloZS7Bh9Q6WE1GKwX+wj2v2PwgmbgxyqwbWoi60jzNggf/Wc3/6vX+Ie09j0aEqHD',
  }
  govuk::user { 'jimg':
    fullname => 'Jim Gumbley',
    email    => 'jim.gumbley@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCsUhHICC7VFtvKC2UGof/uiSZSOX+PY+YTrF268zsEJI6O/xKV1u6oL7IsoeomX7pmiRj/SSvaGOJjGecGfXQNb4NJikvRy/ghxe8WfxLhzUxawWn59mLYRbwMSDlAdW9VvWCm1QCRJGF0ucbBexh3HnDXYr6tgdF1+CP2y9QVhN7Pl5CNIJ9bS4VgjzVUNxRQ707daoFy2zE0oQCPlUTnwmytKq4izhNnZvKIKnUK0jwhVhPcV4ddybsRhmguu53kHzyY3vKVd6BC0y3/dl46xOYvivaZXiYC7YDg2+LEV52xYshvA2iu4GKv9Z4hRPAkOFoJTEUfxHEPAD1UXI5H',
  }
  govuk::user { 'johngriffin':
    fullname => 'John Griffin',
    email    => 'john.griffin@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAukquKh/n3WF7EtgRI+xO97ovId68XkuQ8zRauChAm0wkNz1WsLQAapm62isHGJKlSWTjgO5hLv96OqTfcWUXQVk1wyFAeYR27jo5HtbVNLqZScodBGtb2GmfKLp8IcNQd1C13Jmay/6oub0VnDRAGNX27zRSKyOZKnW5+OqxT+GXPV76iykUw765cLCatdWk0KtMVdJxf0wXz/aO2fccX41oECOvsEWLoDxWu2BwalmzKtRZtbGYOECADhTC7vwT5BXd4KsEWR293KgRXWHKJgdzweI6O3gmIlOIh6uOFJW6JM4BwGx606pnghKANeYOvw4NYuZ8OWolqGJbf1Ai2Q==',
  }
  govuk::user { 'jordan':
    fullname => 'Jordan Hatch',
    email    => 'jordan.hatch@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCezvhfj8oBnCdr2z02HqAJ1HGjBU8X8+W+2jsfxSjEGNgAHD7xROT/YXiETcceG6hGcXtNZqiRRec147Bdj+3EfTxqkzlREv9sAhBD6IJzAXSpMIapL9biNG25wZyw0cGQQepTWeUjsr1WotfwCSS0PP6YHphmNQ6cMINvJlOCkHaFlJhQZ1gpDDRxtLzqTsoIHrVtYrdBEGiEApybVpXpOZEXQpArXF0cZ2lmBLo4NHCJahIRl/MbxUlkJ0sI+uPwhjUKTjpGfCTZI6kexWfiyTpHopb/kURk8DFgnG1Ec/aykJUYgqCABEBrBd/52O/PbvTLSdmglErgkPt+B6HB',
  }
  govuk::user { 'joshua':
    fullname => 'Joshua Marshall',
    email    => 'joshua.marshall@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDlKRtKb2qNbAwM124EtSDwLKh0oaSbd0VoQjFntVUoCxEOnrpqEZK56oQ/F8gHklj6vfy+kHSx8ocqcD3wxavQ9xffe20mJahDh5z4ooH8UvaDEAnxS6hiBPwa0rnqnNykHEdpxzjHsTvJKRWFHN9i62W7YR9VhfBISLhk1yXFIAKypi7gqhVPN2oLg4iEdI1w5e/vJN8oso0DWKOIxr2qD7gX0zjL8kaWsAh7UVEw26gTZlJWFCg1RE1v55iYx1NdFpy6F8/oH/y9gITlf9FrxxGX2ikmuebs+h4/rerNQHUtJOKR1Sbsl1W6vqWiE7qiWj3q+HnOM8ms4PkRuzJn',
  }
  govuk::user { 'kushalp':
    fullname => 'Kushal Pisavadia',
    email    => 'kushal.pisavadia@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAtHtEBO3sARvNZj8F6Ugl4hlp5euXQkvle7Snvh9LhxL+6bJSAaeCSiRYXnqkGi0YpfaKiL3MrebrVILCcIsLsQk0RcTfah0PrRaHqfS7ABfSNYEg7D2/ISekXDvj0nvxIkSsapH/gqQtu9hR/LFUogvJS5WiMJZrlyvFTvkB/q7QqQXuv6MvqNeKf3NkVNKmYHmcf9OuRY46w2uQE18gPJmftUA6oBXpnT30EfIpn5/FFYBdjZY7IHG9EULS4GZXN7PZgIajSbZlNmrvLIYEcFzI90ekCuwonppqODcHSQajTvIu6G0WpqMyycSh0Q10whn4Dw683X2HrfwiSCChUw==',
  }
  govuk::user { 'maxf':
    fullname => 'Max Fliri',
    email    => 'mfliri@thoughtworks.com',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAqKaetBxmZ5PHKODZ9gePehRbGqVR6pp5XCqXwVo04K2lgruMP1OIQBUtHgF/PcoO2EhCv5aZ6J60d8wSvvGDcYcAYYKgkwF744FK9PZVY64q9Vn1XiDwzgM+rHkKBcFkSEx3iZoR7Z0crM2AF/S5R8RKZ9eiAcfC1nZW2O70XUcDb0A2JzhTrAXwvsLLkcqHFiSv8T//D473K9P8Kocf4EuGFT2o5YpZskCykXfLk2g1IiFM7DjwlcEyTcIYEHA5fulMfzn5duWJT5hcxcVuZ8xicYquBVoDKYpxdWTmTye+q77YXTrttXRYl1mybnrzo3QS1i9N0VaIgiPf1FS/pw==',
  }
  govuk::user { 'maxgriff':
    fullname => 'Max Griffiths',
    email    => 'max.griffiths@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDS0kpu/Y3AulX+oVR81Vcxmihs2p/www6OezubEUJRTjlpOHk5kWtGWmNj6mkKa956mxy8NKq7tZxYxjRJ90Y89ieUmEe3hpjzrV45RMZaSo4A67a7pMd4SD5l4LfKlFsBgK56dw/uG+xcAh6PjLDRPBeIVHuMLvGyJK23vrNvYDCCTnQJYX1d7N3H6RniyvUXgz7G/2u7GGdiATrIcjuNUyAV9eR3wFIh9y6z93SR8C2CM8urJQeMhfxPaAARDzkAYJsIVOI+5jEQVfpbsF/+n+GEg43yMsiLBVTGU8KYvnhooYYlkv1Q93GtzGQCVyS1EoxsuDP5Zpu03gSu2JmJ',
  }
  govuk::user { 'mazz':
    fullname => 'Mazz Mosley',
    email    => 'mazz.mosley@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQChjFkBavV2UIc5V5SJOT3P/zfEBun8ggsRV2ObIRrpUrHonJisvMpTDF5Bd++hENKw6KGq56FApAWWmnmzEUxUp3nqYJ+LDW2MxLfMU83gui/oyehJtQiBc6hzU0sIORiiLLUpEtqlB0WHgz1ZGxOYr0Md69EzNUsNDcuEfYwlXVrQRHNDYvDrInWh6Ux9GszFbRyPT7YfmjSyv0d1weUA/qbrSno9UZmyxAkicGsgN/vFRhoik52pD4SEBNfkequDKn/B+mVImFDtZkeC9K3zgVm5khzUPeQ66qpkVxo2C2a2d5iFrdAjTNFDvXAjfmpNNJSX8GGpD10ReKTh8w+x',
  }
  govuk::user { 'minglis':
    fullname => 'Martyn Inglis',
    email    => 'martyn.inglis@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDXl5PLGczafadtLjRlZxYPpHuMPDq5jAtaLtvne8jJllUKcrgtO6Y+tJng91cJftneBFwT2OM5dZx453rmwPaeLwEWXpVUVGPy47uTzTzPvmgIwlAc4qfzDcMsJmwilrJ96Jhwwq/bVkq/+24kJWdf2gvoLUqeV38BBWXZg7NjMiLqoKpAaQEi+gxVsTIw62/c5XHKpdM/MNPFV5Gv/q0G3MO5DyG5I+ZJFs0iiq2/POADSRZ+R9seikhmJskDSGbLEE8fv0jgUJ2Zm28hbVEg2H6G7rfmZ5wRtsm6sTH08cxYKZsZgNiZm/+tM5Hv0D4CKb5BMk+IpSvZtv25sowD',
  }
  govuk::user { 'mwall':
    fullname => 'Mat Wall',
    email    => 'mat.wall@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC5ptHOHTFPDAGZfvEVwp9i1xwcW5yzwTM8XjB1g55l3AE9hdtLgVPx4yr5pgK/5MXOZnEfr+0TizmvMa03OwuTY/BIu4/IuZnvxm0JGY5s2DM0qiswoqdoxNhxsG0CAyI4w+PQj3TN9SCDnoQZ7hQhfRsYnADXQtDwdr0MlUW6lbB31xTsFtBCzTVgI3Epufw7fkZGwhjNFJ2s0gEHMG3QmI/LGV46QtBdJJ29mTjTMOS8xddDilkOxaTtdg7ykVtMk4IVpuekStZOAhXU8x77F6CIJ/2gxFBDo2RhrWmEpTZJWYMxGs6MecAQ47xIRCFK7B3QZu/h9fjCR7o/kaeD',
  }
  govuk::user { 'nick':
    fullname => 'Nick Stenning',
    email    => 'nick.stenning@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQC6kPL0dJKNNOFb6EDh1XcivYi7yf6gmnSeBOwVVAGSxQB5TiBLzp21eSTjsKSVmsaG8AAhde/ve0NFqk7tOz4tKGDGEXPjkBgCUnJzmbB6iJIijGLseZKJ577eXIHRJUgPIqCPOrbmdK0uEwYwXbUKjY2lLRjH4XkkVg4YLVuGlYmpvx9u86GoGLSo9hODbznsE4VKIQv+IKxU8EAccypjDBHkcNiA9nsmkNWG4ZROLc8K+ZedskJBl8jiw9MRWsma5sGF0HYyYyvK9zVdjmQv9phQacSufuCUx4hYAUPU76p40e0VuiR7KXd4bV1aXXLk3tIqoazDm6SK9OL9cJ2lR2e/zdIzmxwTfaNzy2CHZAxd+ed9FTKrKyTMayV255GRfgWK+YkiahMpSpV440ZXpwzu2mbUkJP8DEFkSolybWzNzixjM+aaoHxALq7dDTN5jxpYTENaa6WNC9S1gdoEzDE2d1S9J48qxfPlSxWqPWUZDEOGrD/z0e4mO8y9/Aqru2Vi5yZzolQghcnfcAn6wYE0OSrmVj6ThWD/wDbTXmrpyW2Y3HMQ9Fcndx31nW7Ks3F5wZkG8V3+k2Hxc0tSP7unO6SoaQMe4cm3wYrPvxfi+Gb+Bmj/GdL8MfjuEKm0277jbaD3NsbYuFvWqntyV9WLV/XHkD2asEGnIVNRDw==',
  }
  govuk::user { 'norm':
    fullname => 'Mark Norman Francis',
    email    => 'mark.norman.francis@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA0D6pS3pY+fXcL/vbAcExqTnFUIMYLjlR+MkQOUUqWtlcPSWjKmmUfLDh4nqfu18aiTvdgCW/IPRMhIOnK782x6Hn2KtRBCBSLh7cCdC2cZOt6gl7tjN5/b1s/tNMCf+3fxl2cm8pUVwSz7GXec85OU0mxPQW6KMjPJC7a88RbiU4jrCHKWMj+27GWHhtT+WOWr0R1+w7SyVejyhFajuFuV4r4Kwovon6/ysfEzSza7rbOSa2El/aGDj7RIE91bxoC2JMYKBSXm6rdjGcTEsD0D9HVqKBxzyKQIUlbNOFAFJefj1/kmocKC0bTcu0zRgS/O2kxLeIXWIgjesLxjoITw==',
  }
  govuk::user { 'ops01':
    fullname => '2nd Line Support Secure Laptop Ops01',
    email    => '2nd-line-support@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDSps8g7QXWucBAcSLISkZlRAtCGNg1Cie8VMaR3NgnTWXMW+uCwBjdayS6yIseGC7M45HVACxcKo23VhBlQT9PC/a97nx7laSj2RRTXz2R5cJH68dIk30lhlZIytKfvbVkMbC+46B7WhOhHcPyeG8S8JJnKhTyFeYxuN/VYvclQ08JBlNQm/zzF/rsBMZ9MS1KpGd6J/Rkhci3HysLOruaNRBW/HMc9Ye/XvGdXXk9K7nn84OhBwr1S8yjpo3MN1ivDhl07LbOaKMqWgL5pq7wu1zN4fBXkHKEC9KDzb677duWpeAugL2/BDlF9ZzwjhCBeFrkmnKgPUmRS9Ofr1LJoazblaM4J4x5AhTnsKBkNv+i8KeaqA+2cBv/6RaALlB0hzWDt+0Sj/n2VztWh9E1i0G4vMGtv6QdhJnrynk67YhpSmLltpvU+jjTwHYIAlOTzQU8zAP26iDmxCRhU+ihuDmAHJCGIqRIRJu6+w8Z90WU72dj5oykvt/fAwhkx43iViAtcAlW5vnBepyUEKwshmCovU+tcNFN8MsZ+uv/bi758EDrXUrMbNb4SoeCCSJPMc8FqJz0gsxfR7ykYHYWGHTIOMuOTzbfctwW/WxgGv0ZuV18gWof6JAM1bjUpbHuhMZvVDpaijJIcJTwS+NGUpOr9lqh8v8A9jDpiO1/aw==',
  }
  govuk::user { 'ops02':
    fullname => '2nd Line Support Secure Laptop Ops02',
    email    => '2nd-line-support@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDfMrYDyBol4b3Zq5EWUeIGuTbfj8z7nGYUzf7kZASYA5524nLmd/Fiw40UAxhHRfRW4omYQpyfE/gmeACwIBOpHUW4CC4ZsiqAJiNLNfTVJAcqR/pq9AgbrIsBs7egNtHpi3sCMiHxZqhO9e5OUYDu22T9viCSm2qRYJ2txrsBuvpjnqYslVWSgi7/r38yXkcFSdLLwMHkvFZbpPoa5XEZjxZymMjLS1ZLNKSpKbjQyAAATs8Vh5xezuEt6llXyNVGMBmpOeA2YjUstXI30omSTFenD5viy/8U9HHNXO/SWO/ahBnZhXMMuJKQacwU9mtC8CAsPOHLNHXM8g3AdF/Cm8r+RwDpdYBfGM61TBPIuMocyuLV4s7gpdc9Sogw/42rkr3ECUkTikjj5Mzt2FhXnLS+g7MhJc1v5GYri2+mZWsWIDXpMnMI1lVoU0NTsRfBBNClGVApfb7R5jkSUyfOq0eq96YtDUasYWMrBDJmYGtOhEZ1fzWzfE1cHdTRTezOPdfGIad7M+2WOGetzQ/n+31MCj1bZeb91RHIOqcC2euRRj9377dX+l0655rKBVadksWwxufDXS6xdsvAvOeAPc6JYtbbPxR6bQ3afI3A050E4vm4ZWoP1I2OerV/ABQWZxbwY+GXAmbp1MpOoBcNz8d5noLC5C2NpPIcjPbQXQ==',
  }
  govuk::user { 'ops04':
    fullname => '2nd Line Support Secure Laptop Ops04',
    email    => '2nd-line-support@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDG2CL84SiAak+VqTzYR6CnQPLXCyGOvBTRcICG/Nv7eSgJ6mBKlULQgHU9Xs729YViH+z0ZDfmKvfuISt30jcK+YqfHgFQsv6OphYFZazYVfxUcw/MaRfk8aOYUIPL/slWvdVH9CE0Ux9rm3OcUe6b0pgLu6cJ+d/aRGOjgu7Rx92UYzgdW1n1ZtyzBkSlQY02XlnU6S9ZXdE+tEOGqHa7T4i+EGyQY2EVVIkOt7oCfVd/eJLW9J11rn5LVcF0phwC8rehciNzOli1/AB9mVmq4jqTS32Wc+30S3EYmi9Ra+W2bRlrjXzyMedQTF4FpL9ZHH1o2FJ4UnzECR7w9AW3CQswFZUCRUjuF+NFc4YjsPx1dEDaP3YOkOFqSJ/wmDK5GM2OagAS0tRfdy2H2sYlzaN1kkAo73M9fjH97vcgWC88k7J2tgn+rv2Nxv3UWsLkOYLrfRq3TlOKWd3CX5Cs1XUTL35X6FIqai/KXXdc6qeRw6D2xGmxnf4Fy44QdaFBp3qF9A0PEjVZopr/wtS2fdbfCgHh2VkgkuP216wWUv/ve/Gi41d+siCuHnunds0guiRUJGHOvzO6+3EiJ1HJhR9JEMQgQomm3lMk0ASKVnLwYpq3VDB1u55poTMHmpMUwCts6Yu4DPtkXWxDfN1mNHKyY5jvJCWD4+1JOHwKjQ==',
  }
  govuk::user { 'pbadensk':
    fullname => 'Pawel Badenski',
    email    => 'pawel.badenski@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDKSgHRiOIzlSdubYqlAj4wtz2r1+cGykUcbZyNo6LDckv6Ld1O27VkMrtEVWj4lWQnYPNYTu6giwwUZiHa9D00N1QJpYJWF633hUatRfCzTGLcj1wGiEuKdzheZzJzTG6oCg+9YQF3wR+0lKle7M97PV3zTkFPmdQbKia4ZxNTm9MYBRrCV+R4CAo8RnJKz3pQM9woEo4vIs0OuBPhnte8lSRWrggH/YaOoGATFqW3k5r112Qj1shjX5aVmWuscdfwI3m6mOOBu4617Fxt0OuQiJVa3YlIfL2g2RL121JxP8iKtDUVVIy/aGqDK5Igdf5c+ZvfJ6DPBzYEJmLWrH61',
  }
  govuk::user { 'ppotter':
    fullname => 'Philip Potter',
    email    => 'philip.potter@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAxPK5a2PwUij5Z+/dYKU5oIBVugDOY2QwuXiXsvo8xMoE9AMWYnLmDTgGVZ7VBqtXXuOhvRl7jm38xsFSaB7R0Z6ej48tmemnRKPIN4m7ahUua3Gdlr24/5dXB9QUg50JZsekF/drQivjfRhSTNFOnBhdcfkYy7Zi+tShRHJ/TWpMjFkZ+EBiW6GPYZqyBTOXV6HdPWOePxJkBRpEHcWxoQ+3uBLO1uCOxNAX10d+maFZ0Ql8zEvdAZJqMprC7LCBKKZBp5pw8mgSAIAHsPljnZ+dvabY4+WBd0qOvk4iSkjWad96LcPw8EyvhcL0+PK4gGLD1jb30y7kwxCc7EzggQ==',
  }
  govuk::user { 'psd':
    fullname => 'Paul Downey',
    email    => 'paul.downey@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAABIwAAAIEA7r1lq8GxI3MtOz+38NcQEaIHKBM9lmgLLoEi3yHpP2LGld6H5UeAxg12sjsVsWsEwany1xpWI+kE7HLwrdXim4DwObAypgr92SlNUClz8iVUZmh0K/Y3gXvTwfM5/hqwtXrObm4i9xNqh2wCoa5HaWqRF9g1jZm+asMnW4r4FQ0=',
  }
  govuk::user { 'robyoung':
    fullname => 'Rob Young',
    email    => 'rob.young@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC7Ow1NSyFzV31HAuIf7FFrGIki01sM4+PUdnHrBtTqNFrraGTqcrRKOs8oHtDMhiGC9MPQWvgTMo/sDdAYp3W5SelBJX3L2J0ixKU9D7FNn963SGxWgfuZGTYvu50uDbPwGXH/FXaa99lo3FDv4o2hodC3TRPISAIS3fGXD/K1RuczvIeWfrYAUg2yC01Jv6XzJvHeVVfgQkp0YkV2J0Y5+hXJlcyxmFMdOZeXF5o68ypac/KEu5ksmFX+9h8YPjJ9vidVqzDQosSTA/2W8zTiqTztHeAFOgp/uw8XgLxzel8FLTE6xyu0WSAQHVTZfm5r6U/blft/Q3gcDldrLzRD',
  }
  govuk::user { 'rthorn':
    fullname => 'Russell Thorn',
    email    => 'russell.thorn@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDUwreoN2gpbNQsoZJk81aMZWHWOnODDuUDh1zlyVTbxlk1wKZ8UAyYLLXJoIAJ5d1gxy08s/ru65eUltbjxAZe8ipBDwIDkRYevCGFJ/oR1GWSeCV9+eMqFQ+aiA7MQQDYLQImap9XqTNgIXUS5oLGl5woJGBs1GO9pV3tLgTU3LmIV1e5h3bcbkLbE1GlA9BWpw/Bx63sgpN6F0wRA/dgldZ27PEnzaJtStoUQUYuAW9mFGwOI1M8XM00MfrxGXqiwRbIzl8idu7yKKi5MxmP3JYIXnzSGYupoPAxqvZCIzCk0avwuKWlMQNwpwt5SKd5Kq3bbUcbrzYWV+uxWK/H',
  }
  govuk::user { 'rujmah':
    fullname => 'Robin Mayfield',
    email    => 'robin.mayfield@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQCyDQhsLFop36EQGOpiBGrMcL/At7JR7813uUbWEOqim/nsDmpr2PnuoBthC6rG76ZhmlHxJS8EZ3e4pT0XQJJBl61wa/MMxag+zvikUU+/srsrbrhE8p0mrun1lG5S/3IJA3SD+mrpr53jDoxHtYVnw3m0fr5YyairEwEa38fAbqH+FlzLOA/dVXBBdHp8dYpyRpXdJpPPhu1TOSZUL+Y6HrOp9IFe2sMHQWcojm5hHqLJSw9kW+D9vhJCBmfkmX/Rwt+SXKqt9r0YxhDABYRJX+BqN2/ZuufdAZQle97v39vogvNQSL6Tol7QuO3MsE6gkhTxy9uZyUU+sQrmJkLPlQafLTKsJjn/wA+UDb81l1LuQbZwqBNR1O20HN4C3h0L3/mjixjWJ7x14pR1jAaOj2Cxv3rQZOKqAvnjvlvTq+c8IG7ylKzF9jRVlAUmXnNCjIZYC/6RtybqsilOXafyanLLteumREJ7az1Gp6uZRHyMe9NFoBewStMfad03qTg1IjIbbnof9K6wR4kJsZR1a9me+kSNszk+eF4PtcxXekiRvKdJxDXVQVtpvlBFmXTrNEYQLV4hFUMYxjjjxhCAIIKnnM73T7PLI7+tfEWEa2dqyOEoKmsVcI4CTGrK6JhNzFriwTtZ2AGgebe4xW6a8IlYO8Laqp2zzSg5jkCbJQ==',
  }
  govuk::user { 'ssharpe':
    fullname => 'Sam Sharpe',
    email    => 'sam.sharpe@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAyNoMftFLf3w0NOW7J0KUwOx9897CU352n3zKD3p/GCcdH4eMv1QI0BhjItZplWG8TzFSBfWOOSruRh1Gksa1l1jiQcisEio6Wr7kZ7bpvMMA45ZoaDc26HTB+r0BZkNn7Lwwxxvy+1pbqStnnKzb9OTYIyVkb495LS0x1EL/P9S/NWtpm8ZULa1JDplYMA5SqMZnhmlGAXdh8UnjdcdOgOm2ngA+geJBSzVbABECiIAklHU1PRzOtrq8SuO8JmXW6NkuL0aabdTgE6noIm+Nn7T5ufZpOpIGYimVI8+mu+efcBzAp5Q0vTRgSBLfggdczZbFfPXpIt1Ib+LEf+Cuqw==',
  }
  govuk::user { 'stevelaing':
    fullname => 'Steve Laing',
    email    => 'steve.laing@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA543UsOyJDz1d1CnCj/1QdHEgjeKO9Ks7VY4ZvW1YPpaKdvsSHQ1y5TE34X5RwX1GPq1kKB3rK1XO7N/hIS7AjwS/NuCQqPgSl4zA4sgsPRNiZkArFMQiduQmns0WJ60gf8C6P+7+L9XGvtIfRQyeW29eYtGxT/Gl0em+V9xsSFNNp3NrmVzhc+2uNbCShR3c5WRqDdB7E4xUydNNQHaeKZiXeVw0ZjjvVkqGvO8jRATpoOAdP5wva4+rVLmPcB9yvTiHkDtekQ86CejJAuDJL0chhEa7vgnEwn5s71HNsTL3SHkvpI9eyIiL86v9bDL2gt0tXzcdo8GA1SjMUvUiXQ==',
  }
  govuk::user { 'timpaul':
    fullname => 'Tim Paul',
    email    => 'tim.paul@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCUMq+KMPX2kf9BEUmV6yAwIm9FPSaxmc9AmqXtyeVA2SieO7w1O+7f8fbTkqfc6ZZUs8fys6ofMdQBz97yxmUAECNCIFJ5oOv7mcxedHNdHTIdIveVKnqrdfTLAE3aOinrZqNUIILkJ6p3PCAS9aJoa6T3hFELGBFkAVtMjvd1ZligAo7ZKu7GEitswekDDZOH56NLYBb/06TA5fNAPPJv+5V6NhFF6CRH3EqqzjxSHZjlUsJEiYafD2HbccFWr/sQS66i3bUMyh5VJYxEF2JO1Xc2wE1yS/OdxJ7D10SgUYIV4Rq4HMuXhMkEQ8atrH2srHlD2EkQZBA25EHkKqmN',
  }
  govuk::user { 'tombye':
    fullname => 'Tom Byers',
    email    => 'tom.byers@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAoQE7BilQWCMv1ATdKqgga6Q8nMUkNZNK42rW7+yMEPulrV9JCFOMtzKaYNfn1Iy1qXK5CH8m/rBenDc0Ra5RM5rPHug9asj7fVhtsKolFqzC5FlCIfk9UHlz9JvEjOGkyCbJ4vCiqKgTa1sgyQ8Wx/DeAD+/IWpGcMAnMLM/OqiVOB+1Ihiwg20psEM6+4mmPwGrIZsGd8mtjvQsnRdqKtPDt3W+AZudzJ3PhVojYKH20hm3HMhv5zj9tdEKQptvrP2AwicyO3lwXQI4Yn4GZx5iDTOmmlZ45oacJGRhHhZ4ycOo6WKmOFaVjz9lQZ9XhkvBUyE7PvPLKIfGVgHQuQ==',
  }
  govuk::user { 'tombyers':
    fullname => 'Tom Byers',
    email    => 'tom.byers@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDFJVtKolj8BTxqM4O0BOjmrTeQK5rq16kEC/1vb+KwTA5T5Rn1zQb9avPKYwa/CYYnffmsJXS7k5Fm5LQebx6xETbCSEmEKzNiwvFiYBVlw9iT17EBQhiALrylkgnb6K3bYX7pPS6j6reA5+s05KX9/U4IsPRse6XoKldzmk+ID47V3l/bDUwH26DusMGnw25uqpOxtdZhOzpFh6iEvdqp4xjcFldinC929TlV+fanoyR14p9fCfDLu/o1dsm9jnqpEWx+xQByQ0GaUQHa/j9bT/oY2H2WoQqfM9YPzhpQkGlKQDIJ9dHFQiGSD6fE6ZIxFH+pX3T5Qb9IJ6pMwnsn',
  }

  # -------------------------------------------------------------------------

  # Ensure defunct users are absent
  govuk::user { [
    'craig',
    'i0n',
    'jamesweiner',
    'jgriffin',
    'kief',
    'mneedham',
    'paulb',
    'ssheth',
    'steve',
    'ukini',
  ]:
    ensure => absent
  }
}
