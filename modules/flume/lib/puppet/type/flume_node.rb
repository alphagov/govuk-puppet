# https://github.com/chetan/puppet-flume_node/blob/master/lib/puppet/type/flume_node.rb
require 'tempfile'

Puppet::Type.newtype(:flume_node) do
  @doc = "Puppet type for configuring Flume nodes with the Master"

  newparam(:name) do
    desc "logical node name"
  end

  newparam(:source) do
    desc "source config"
  end

  newparam(:sink) do
    desc "sink config"
  end

  newparam(:master) do
    desc "master hostname"
  end

  newproperty(:ensure) do
    desc "Whether the resource is in sync or not."

    defaultto :insync

    def retrieve
      `flume shell -q -c #{resource[:master]} -e getconfigs 2>/dev/null | egrep '^#{resource[:name]}' | grep -v null`
      ($? == 0 ? :insync : :outofsync)
    end

    newvalue :outofsync do
      # TODO
    end

    newvalue :insync do
      master = resource[:master]
      name = resource[:name]
      source = resource[:source]
      sink = resource[:sink]

      conf = <<-EOF
connect #{master}
exec unconfig #{name}
exec decommission #{name}
exec purge #{name}
exec config #{name} '#{source.gsub(/\n/, '\n')}' '#{sink.gsub(/\n/, '\n')}'
exec refresh #{name}
EOF

      Tempfile.open("flume-") do |tempfile|
        tempfile.write(conf)
        tempfile.close
        `cat #{tempfile.path} | flume shell -q 2>/dev/null`
      end
    end
  end
end
