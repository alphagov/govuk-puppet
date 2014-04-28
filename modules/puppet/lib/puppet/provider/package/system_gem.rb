require 'puppet/provider/package/gem'

Puppet::Type.type(:package).provide :system_gem, :parent => :gem, :source => :gem do
  desc "Install gems to system Ruby, ignoring current rbenv environment"
  has_feature :versionable

  # run an arbitrary method with ENV scrubbed of rbenv settings
  def self.with_clean_rbenv_environment
    original_env = ENV.to_hash
    ENV.delete 'RBENV_VERSION'
    ENV['PATH'] = ENV['PATH'].
      split(File::PATH_SEPARATOR).
      reject{|x| x =~ %r{rbenv/versions}}.
      join(File::PATH_SEPARATOR)
    yield
  ensure
    ENV.replace(original_env)
  end

  # set PATH and unset RBENV_VERSION when executing a command
  def self.execute(*args)
    with_clean_rbenv_environment do
      super
    end
  end

  # set PATH and unset RBENV_VERSION when executing a command
  def execute(*args)
    self.class.with_clean_rbenv_environment do
      super
    end
  end

  # set PATH when resolving gemcmd via Puppet::Util.which
  def self.command(cmd_sym)
    with_clean_rbenv_environment do
      super
    end
  end

  # set PATH when calling gemcmd() directly
  def self.gemcmd(*args)
    with_clean_rbenv_environment do
      super
    end
  end
end
