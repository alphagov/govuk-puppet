require_relative '../../../../spec_helper'

describe "router::assets_origin", :type => :class do

  describe "asset_routes targets" do
    let(:asset_routes) { YAML.load_file(File.expand_path("../../../../../hieradata/common.yaml", __FILE__))['router::assets_origin::asset_routes'] }

    let(:all_hostnames) {
      subject.call.resources.each_with_object([]) do |resource, hostnames|
        next unless resource.type == "Host"
        hostnames << resource.title
        hostnames << resource[:host_aliases]
      end.flatten.compact
    }

    let(:hiera_config) { File.expand_path("../../../../../spec/fixtures/hiera/real_data.yaml", __FILE__) }

    context "in a production-like environment" do
      let(:facts) {{ :environment => 'production' }}
      let(:pre_condition) { "include hosts::production" }

      it "should have host entries for each route target" do
        asset_routes.each do |_, target|
          hostname = "#{target}.publishing.service.gov.uk"
          message = "asset_routes point at non-existent host '#{hostname}' in production"
          expect(all_hostnames).to include(hostname), message
        end
      end
    end

    context "on the dev VM" do
      let(:facts) {{ :environment => 'development' }}
      let(:pre_condition) { "include hosts::development" }

      it "should have host entries for each route target" do
        asset_routes.each do |_, target|
          hostname = "#{target}.dev.gov.uk"
          message = "asset_routes point at non-existent host '#{hostname}' on the dev VM"
          expect(all_hostnames).to include(hostname), message
        end
      end
    end
  end
end
