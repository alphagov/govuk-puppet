require 'parallel_tests'
require 'parallel_tests/cli'

namespace :spec do
  desc "Run puppet specs"
  task :normal do
    matched_files = FileList[*get_modules.map { |x| "#{x}/spec/**/*_spec.rb" }]

    cli_args = ['-t', 'rspec']
    cli_args.concat(matched_files)

    # FIXME: Puppet 2.7 is noisy on Ruby 1.9
    ENV['RUBYOPT'] = (ENV['RUBYOPT'] || '') + ' -W0'

    $stderr.puts '---> Running puppet specs'
    ParallelTest::CLI.run(cli_args)
  end

  desc "Run govuk::node class specs"
  RSpec::Core::RakeTask.new(:nodes) do |t|
    t.pattern = get_modules.map { |x| "#{x}/spec/**/govuk_nodes_spec_optional.rb" }
    # FIXME: Puppet 2.7 is noisy on Ruby 1.9
    t.ruby_opts = '-W0'
    t.rspec_opts = '--color -fd'
  end
end

desc "Run rspec"
task :spec => 'spec:normal'
