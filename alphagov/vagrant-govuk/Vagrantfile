BOX_VERSION = "20121220"
BOX_DIST    = "precise"
BOX_NAME    = "govuk_dev_#{BOX_DIST}64_#{BOX_VERSION}"
BOX_URL     = "http://gds-boxes.s3.amazonaws.com/#{BOX_NAME}.box"

Vagrant::Config.run do |config|
  config.vm.box = BOX_NAME
  config.vm.box_url = BOX_URL
end
