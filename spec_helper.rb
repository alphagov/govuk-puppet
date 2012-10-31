require 'csv'
require 'rspec-puppet'

module MockExtdata

  def set_extdata(h)
    @mock_extdata = h
  end

  def update_extdata(h)
    @mock_extdata.merge!(h)
  end

  def setup_extdata_stubs
    @mock_extdata ||= {}

    old_exists = File.method(:exists?)
    File.stub(:exists?) do |f|
      if f =~ /extdata\/[^\/]*\.csv$/
        true
      else
        old_exists.call(f)
      end
    end

    old_read = CSV.method(:read)
    CSV.stub(:read) do |f, *args|
      if f =~ /extdata\/[^\/]*\.csv$/
        @mock_extdata.to_a
      else
        old_read.call(f, *args)
      end
    end
  end

end

HERE = File.expand_path(File.dirname(__FILE__))

RSpec.configure do |c|
  c.module_path = File.join(HERE, 'modules')
  c.manifest    = File.join(HERE, 'manifests', 'site.pp')

  c.include MockExtdata

  c.before do
    setup_extdata_stubs
    set_extdata({ 'app_domain' => 'test.gov.uk' })
  end
end
