require 'open3'
require 'parallel_tests'
require 'rspec/core/rake_task'

desc "Use the basic rspec rake task with no options WARNING: slow"
RSpec::Core::RakeTask.new(:rspec_basic_mode)

CARRENZA_EXCLUDED_NODE_CLASSES = %w[
  bouncer
  cache
  calculators_frontend
  ckan
  content_data_api_db_admin
  content_store
  db_admin
  draft_cache
  draft_content_store
  draft_frontend
  email_alert_api_db_admin
  frontend
  gatling
  licensing_frontend
  licensing_backend
  mapit
  mirrorer
  publishing_api_db_admin
  router_backend
  search
  transition_db_admin
  warehouse_db_admin
]

AWS_EXCLUDED_NODE_CLASSES = %w[
  api_lb
  api_mongo
  api_redis
  ci_agent
  ci_master
  development
  email_alert_api
  email_alert_api_postgresql
  licensing_mongo
  mysql_backup
  mysql_master
  mysql_slave
  performance_mongo
  postgresql_primary
  postgresql_standby
  publishing_api_postgresql
  redis
  transition_postgresql_master
  transition_postgresql_primary
  transition_postgresql_slave
  transition_postgresql_standby
  whitehall_backend
  whitehall_mysql_backup
  whitehall_mysql_master
  whitehall_mysql_slave
]

namespace :spec do
  desc "Run puppet specs normally (in parallel)."
  task :normal do
    matched_files = FileList[*get_modules.map { |x| "#{x}/spec/**/*_spec.rb" }]

    cli_args = ['-t', 'rspec']
    cli_args.concat(matched_files)

    $stderr.puts '---> Running puppet specs'
    ParallelTests::CLI.new.run(cli_args)
  end

  desc "Run govuk::node class specs"
  task :nodes do
    # Don't attempt to instantiate these classes as they aren't concrete
    # machine classes, and therefore aren't intended to be instantiated directly.
    $nodes_spec_blacklist_classes = %w(
      app_server
      asset_base
      base
      postgresql_base
      redis_base
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

    carrenza_node_classes = node_classes - CARRENZA_EXCLUDED_NODE_CLASSES
    aws_node_classes = node_classes - AWS_EXCLUDED_NODE_CLASSES

    NUM_PROCESSES = [
      Facter.value('processorcount').to_i,
      (
        carrenza_node_classes.length +
        aws_node_classes.length
      )
    ].min

    exit_status = true
    [
      ['aws', aws_node_classes],
      ['carrenza', carrenza_node_classes]
    ].each do |(hosting, hosting_node_classes)|
      pids = []
      spec_file = File.expand_path('../../../modules/govuk/spec/classes/govuk_nodes_spec_optional.rb', __FILE__)

      1.upto(NUM_PROCESSES) do |p|
        pids << Process.fork do
          tmp_classes = hosting_node_classes
                          .sort
                          .each_slice(NUM_PROCESSES)
                          .map { |group| group[p-1] }
                          .compact

          output, status = Open3.capture2e({'classes' => tmp_classes.join(","), 'hosting' => hosting}, 'rspec', spec_file)
          $stderr.puts output
          exit status.exitstatus
        end
      end

      pids.each do |pid|
        _, status = Process.wait2(pid)
        exit_status = false unless status.success?
      end
    end

    raise "One or more nodes did not compile" unless exit_status
  end
end

desc "Run rspec"
task :spec => ['spec:normal', 'spec:nodes']
