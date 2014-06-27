require_relative '../../../../spec_helper'

# Put module's plugins on LOAD_PATH.
dir = File.expand_path('../../', File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

describe 'govuk_check_hostname_facts' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  context 'hostname is not set' do
    before(:each) do
      expect(scope).to receive(:lookupvar).with('::hostname').and_return(nil)
      allow(scope).to receive(:lookupvar).with('::domain').and_return('example.com')
      allow(scope).to receive(:lookupvar).with('::fqdn').and_return('myhost.example.com')
    end

    it 'should raise an error' do
      expect {
        scope.function_govuk_check_hostname_facts([])
      }.to raise_error(
        Puppet::Error,
        "govuk_check_hostname_facts: Cannot proceed without 'hostname' fact"
      )
    end
  end

  context 'domain is not set' do
    before(:each) do
      allow(scope).to receive(:lookupvar).with('::hostname').and_return('myhost')
      expect(scope).to receive(:lookupvar).with('::domain').and_return(nil)
      allow(scope).to receive(:lookupvar).with('::fqdn').and_return('myhost.example.com')
    end

    it 'should raise an error' do
      expect {
        scope.function_govuk_check_hostname_facts([])
      }.to raise_error(
        Puppet::Error,
        "govuk_check_hostname_facts: Cannot proceed without 'domain' fact"
      )
    end
  end

  context 'fqdn is not set' do
    before(:each) do
      allow(scope).to receive(:lookupvar).with('::hostname').and_return('myhost')
      allow(scope).to receive(:lookupvar).with('::domain').and_return('example.com')
      expect(scope).to receive(:lookupvar).with('::fqdn').and_return(nil)
    end

    it 'should raise an error' do
      expect {
        scope.function_govuk_check_hostname_facts([])
      }.to raise_error(
        Puppet::Error,
        "govuk_check_hostname_facts: Cannot proceed without 'fqdn' fact"
      )
    end
  end

  context 'everything present' do
    before(:each) do
      expect(scope).to receive(:lookupvar).with('::hostname').and_return('myhost')
      expect(scope).to receive(:lookupvar).with('::domain').and_return('example.com')
      expect(scope).to receive(:lookupvar).with('::fqdn').and_return('myhost.example.com')
    end

    it 'should not raise an error' do
      expect {
        scope.function_govuk_check_hostname_facts([])
      }.not_to raise_error
    end
  end
end
