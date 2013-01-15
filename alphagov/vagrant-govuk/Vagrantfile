BOX_VERSION = "20121220"
BOX_DIST    = "precise"
BOX_NAME    = "govuk_dev_#{BOX_DIST}64_#{BOX_VERSION}"
BOX_URL     = "http://gds-boxes.s3.amazonaws.com/#{BOX_NAME}.box"

NODES = {
  :development => {:ip => "172.16.200.10" },
}

Vagrant::Config.run do |config|
  NODES.each do |node_name, node_opts|
    config.vm.define node_name do |c|
      c.vm.box = BOX_NAME
      c.vm.box_url = BOX_URL
      c.vm.host_name = ENV['VAGRANT_HOSTNAME'] || 'vm'

      c.vm.network :hostonly, node_opts[:ip]

      # Mitigate boot hangs.
      c.vm.customize ["modifyvm", :id, "--rtcuseutc", "on"]

      c.ssh.forward_agent = true
      c.vm.share_folder "govuk", "/var/govuk", "..", :nfs => true
    end
  end
end
