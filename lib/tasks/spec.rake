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

  def get_node_classes(legacy_classes=false)
    # Don't attempt to instantiate these classes as they aren't concrete
    # machine classes, and therefore aren't intended to be instantiated directly.
    abstract_node_classes = %w(
      app_server
      asset_base
      base
      postgresql_base
      redis_base
      transition_postgresql_base
    )

    # The following node classes have been deprecated in the migration to AWS
    legacy_node_classes = %w(
      api_lb
      api_mongo
      backend_lb
      ci_agent
      ci_master
      docker_backend
      frontend_lb
      licensing_mongo
      mysql_backup
      mysql_master
      mysql_slave
      performance_mongo
      postgresql_primary
      postgresql_standby
      transition_postgresql_master
      transition_postgresql_primary
      transition_postgresql_slave
      transition_postgresql_standby
      warehouse_postgresql
      whitehall_mysql_backup
      whitehall_mysql_master
      whitehall_mysql_slave
      development
    )

    if ENV["classes"]
      node_classes = ENV["classes"].split(",")
    elsif legacy_classes
      node_classes = legacy_node_classes
    else
      class_dir = File.expand_path("../../../modules/govuk/manifests/node", __FILE__)
      all_node_classes = Dir.glob("#{class_dir}/s_*.pp").map { |filepath|
        File.basename(filepath, ".pp")[2..-1] # Strip leading s_
      }

      node_classes = all_node_classes
      node_classes -= abstract_node_classes
      node_classes -= legacy_node_classes
    end

    return node_classes
  end

  def run_node_specs(legacy=false)
    node_classes = get_node_classes(legacy)

    $stderr.puts "---> Running node specs for #{node_classes.join(', ')}"

    num_processes = [
      Facter.value('processorcount').to_i,
      node_classes.length
    ].min

    node_classes = node_classes.sort.each_slice(num_processes)

    pids = []
    spec_file = File.expand_path('../../../modules/govuk/spec/classes/govuk_nodes_spec_optional.rb', __FILE__)

    1.upto(num_processes) do |p|
      pids << Process.fork do
        tmp_classes = node_classes.map { |group| group[p-1] }.compact
        rspec_environment = {'classes' => tmp_classes.join(',')}
        if legacy
          rspec_environment['legacy'] = 'true'
        end

        output, status = Open3.capture2e(rspec_environment, 'rspec', spec_file)

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

  desc "Run govuk::node class specs"
  task :nodes do
    run_node_specs()
  end

  desc "Run govuk::node class specs (legacy; pre AWS migration)"
  task :legacy_nodes do
    run_node_specs(true)
  end
end

desc "Run rspec"
task :spec => ['spec:normal', 'spec:nodes', 'spec:legacy_nodes']
