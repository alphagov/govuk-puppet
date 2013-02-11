require 'parallel_tests'
require 'parallel_tests/cli'

desc "Run rspec"
task :spec do
  matched_files = FileList[*get_modules.map { |x| "#{x}/spec/**/*_spec.rb" }]

  cli_args = ['-t', 'rspec']
  cli_args.concat(matched_files)

  $stderr.puts '---> Running puppet specs'
  ParallelTest::CLI.run(cli_args)
end
