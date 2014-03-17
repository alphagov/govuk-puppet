require 'stringio'
require 'puppet/util/log'

# FIXME: Remove when we don't provision/bootstrap with Puppet < 3.4
if Puppet::PUPPETVERSION.to_f < 3.4
  Puppet::Util::Log.create({
    :level   => :warning,
    :source  => __FILE__,
    :message => "Monkey-patching FileSystem::File and Puppet::FileBucket::File for upgrade to Puppet >= 3.4",
  })

  # https://tickets.puppetlabs.com/browse/PUP-1603
  module Puppet::FileSystem
    class Puppet::FileSystem::File
      def self.new(path)
        self.reload
        Puppet::FileSystem::File.new(path)
      end

      def self.method_missing(m, *args)
        self.reload
        Puppet::FileSystem::File.send(m, *args)
      end

      def self.reload
        Puppet::Util::Log.create({
          :level   => :warning,
          :source  => __FILE__,
          :message => "Reloading and proxying call for Puppet::FileSystem::File",
        })

        load 'puppet/file_system/file.rb'
      end
    end
  end

  # https://github.com/puppetlabs/puppet/commit/1df4848db42012fc70faa8b035876bace192e82d
  Puppet::FileBucket::File.class_eval do
    def size
      contents.size
    end

    def stream
      StringIO.new(contents)
    end
  end
end
