# Create the laurentcurau user
class users::laurentcurau {
  govuk_user { 'laurentcurau':
    fullname => 'Laurent Curau',
    email    => 'laurent.curau@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5PEpdd24PnBZ2nAULv6kQvi7hRvm4Ge/akzoJq25bD3f5HON8J0tiSgdLuhiCLayZneLGcNaPFli9k+CEL3CwMegWIJt1T/VCOiwbw7kMjxz9EFZkkh3giXpL3PsyQQIySfA73uG1rv7wsxPCnyc6zDX39UCSf8JUc9Da6dv/DZuZWun4W2sc3HbHxv0fCLIGTQeCyNXPLM86HZxKtm4b+s/qiJIE5GU2y2MenfMB824WJQBina7U9jDI1zRr/I1f+AylY76JFT8GdrZtmRoYguClvd1DX3YugptjtxctpNQur3KT79NH1lzxBKbLG9W9oLhUpEGUaSS85bJeKDbWwP1M3lxzmyNlMHioss/yom5QNSsrgtZ3o03fh7G3p+P5ZislCI6+bM2YXRcfRgOiuDRtbveIFx5KURHUA3ySJ/ZJ8DiRzXOuCWliT4z1BZ9YcSeFAVu+1vCxrMu9T/uw8n7fWrMxzFVu0IyoHikJJiGRXXJFvmYav8tpzCDPl/6AH9B4NVZvuwNhfvpvV8nLd6qHvb4sdXo57oUurc+JYxJZT+KSd/D+cSp/whCn9jc9ER0WOBpPIMmJYQc/UvsXLyH1K2k3qf5laxaIl1PrdWzJhh2fiN+LD1FYmXwMF859c9ZOwvMTgasV9O/fIq32voaJe8JUXVLqHnAmFGlUMQ== laurent.curau@digital.cabinet-office.gov.uk',
  }
}
