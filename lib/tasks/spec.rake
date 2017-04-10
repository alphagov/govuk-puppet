require 'open3'
require 'parallel_tests'
require 'parallel_tests/cli'
require 'rspec/core/rake_task'

desc "Use the basic rspec rake task with no options WARNING: slow"
RSpec::Core::RakeTask.new(:rspec_basic_mode)

namespace :spec do
  desc "Run puppet specs normally (in parallel)."
  task :normal do
    matched_files = FileList[*get_modules.map { |x| "#{x}/spec/**/*_spec.rb" }]

    cli_args = ['-t', 'rspec']
    cli_args.concat(matched_files)

    $stderr.puts '---> Running puppet specs'
    ParallelTest::CLI.run(cli_args)
  end

  desc "Run govuk::node class specs"
  task :nodes do
    # Don't attempt to instantiate these classes as they aren't concrete
    # machine classes, and therefore aren't intended to be instantiated directly.
    $nodes_spec_blacklist_classes = %w(
      api_postgresql_base
      app_server
      asset_base
      base
      postgresql_base
      redis_base
      transition_postgresql_base
    )

    # get the list of machine classes
    def get_node_classes
      if ENV["classes"]
        ENV["classes"].split(",")
      else
        class_dir = File.expand_path("../../../modules/govuk/manifests/node", __FILE__)
        all_class_name = Dir.glob("#{class_dir}/s_*.pp").map { |filepath|
          File.basename(filepath, ".pp")[2..-1] # Strip leading s_
        }
        all_class_name.reject {|c| $nodes_spec_blacklist_classes.include?(c) }
      end
    end

    $stderr.puts '---> Running node specs'

    node_classes = get_node_classes

    NUM_PROCESSES = [
      Facter.value('processorcount').to_i,
      node_classes.length
    ].min

    node_classes = node_classes.sort.each_slice(NUM_PROCESSES)

    pids = []
    spec_file = File.expand_path('../../../modules/govuk/spec/classes/govuk_nodes_spec_optional.rb', __FILE__)

    1.upto(NUM_PROCESSES) do |p|
      pids << Process.fork do
        tmp_classes = node_classes.map { |group| group[p-1] }.compact

        output, status = Open3.capture2e({'classes' => tmp_classes.join(",")}, 'rspec', spec_file)
        $stderr.puts output
        exit status.exitstatus
      end
    end

    exit_status = true

    pids.each do |pid|
      _, status = Process.wait2(pid)
      exit_status = false unless status.success?
    end

    raise "One or more nodes did not compile" unless exit_status
  end
end

desc "Run rspec"
task :spec => ['spec:normal', 'spec:nodes']
