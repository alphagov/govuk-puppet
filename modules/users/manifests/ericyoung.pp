# Creates the ericyoung user
class users::ericyoung {
  govuk_user { 'ericyoung':
    fullname => 'Eric Young',
    email    => 'eric.young@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDZi2R6hltj/SDZ/5Rl9o+2aTuOPyvZnYck3DvD5vMnIUPpK+yjI0ln4fVe2tzhOBNHe3RFrVfd7wLLrGB/QCzsz4STM0ShySeS2/mfxZPuvye27xJSZOaMkCH92Y/PVMkKHMC8ohjPhW1tm4k9bdIc6aD6kP5B04LfaRZ2RScuvm04ftqBZvmtnwl0PVo5TJGLOewasO+LjcEjWDZeaqydAFDsCKMzS13cWN6TzsEjgYBr3YLa7gTnMeDCrkIW5GPhJYMam5UNk33WS9YuYmW12CjC8kaV2xw/kPd8I1oxnzeAxSLJBn31lzx0HxIxPBBe/4YxaE59sDS6SWMZsGd+oZgC/h+/m5JgIsT25zAcTB6KvbUYBRWDeYR/OfIeQc9X+opb35v84e0fpVoF5xVcOUO3h9uf3rmhnvvnanSe53Eu47a66WASiDwxpqEmODrjJzubauEHz/fh5THqgy8QypTtsa9wWYZFp5tmi9xDESP9/2Kg1Ql7psvhxoRKFLl2mW07uQJaMUTxK2IcIffD10iv8rOl4Fn3Qf9BkrzFVv58LCpuZEPFCtFp3d2kSVi/8AiNUSRh9HHlCc+Xi0TED0WEpj3XcJ7CEV5OagM5y/8FD3bOqcYgKOlDDDwBQOmMAtteBi/ZbTyWc7hVRNOtzD+EEK5Adpm09BuaIuPoiw== eric.young@digital.cabinet-office.gov.uk',
  }
}
