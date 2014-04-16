# reset_local reinstates `LIBRARIAN_PUPPET_MODE: local` in
# `.librarian/puppet/config` because some commands have a habit of unsetting
# it if they aren't or can't be run with `--local`.
def librarian_run(args, reset_local=false)
  ret = system("librarian-puppet #{args} --destructive --strip-dot-git")
  system("librarian-puppet config mode local --local") if reset_local
  ret or fail
end

desc "Common librarian-puppet tasks"
namespace :librarian do
  desc "Install modules from local cache"
  task :install do
    librarian_run('install --local')
  end

  desc "Install modules and update cache"
  task :package do
    librarian_run('package --clean', true)
  end
end
