require 'parallel_tests'
require 'parallel_tests/cli'

namespace :spec do
  desc "Run puppet specs"
  task :normal do
    matched_files = FileList[*get_modules.map { |x| "#{x}/spec/**/*_spec.rb" }]

    cli_args = ['-t', 'rspec', '-o']
    cli_args.concat(matched_files)

    $stderr.puts '---> Running puppet specs'
    ParallelTest::CLI.run(cli_args)
  end

  desc "Run govuk::node class specs"
  RSpec::Core::RakeTask.new(:nodes) do |t|
    t.pattern = get_modules.map { |x| "#{x}/spec/**/govuk_nodes_spec_optional.rb" }
    t.rspec_opts = '--color -fd'
  end
end

desc "Run rspec"
task :spec => 'spec:normal'
