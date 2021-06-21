# Override the standard virtualenv_version fact definition since the newer 
# version of virtualenv returns a different version string, i.e:
# old versions return for example: 10.0.1 while newer versions return:
# 20.4.7 from /opt/python2.7/lib/python2.7/site-packages/virtualenv/__init__.pyc

Facter.add("virtualenv_version") do
  has_weight 2000
  setcode do
    if Facter::Util::Resolution.which('virtualenv')
      match=Facter::Util::Resolution.exec('virtualenv --version 2>&1').match(/^(\d+\.\d+\.?\d*).*$/)
      if match.nil?
        Facter::Util::Resolution.exec('virtualenv --version 2>&1').match(/^virtualenv (\d+\.\d+\.?\d*).*$/)[1]
      else
        match[0]
      end
    end
  end
end
