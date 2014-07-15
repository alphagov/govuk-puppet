require_relative '../../../../spec_helper'

# Put module's plugins on LOAD_PATH.
dir = File.expand_path('../../', File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

describe 'govuk_check_user_naming' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  describe 'argument parsing' do
    it 'should raise an error for less than 3 arguments' do
      args = %w{one two}
      expect {
        scope.function_govuk_check_user_naming(args)
      }.to raise_error(ArgumentError, /given 2 for 3$/)
    end

    it 'should raise an error for more than 3 arguments' do
      args = %w{one two three four}
      expect {
        scope.function_govuk_check_user_naming(args)
      }.to raise_error(ArgumentError, /given 4 for 3$/)
    end
  end

  describe 'invalid' do
    describe 'username does not match fullname' do
      it 'should raise an exception' do
        args = [
          'jsmith',
          'John Smith',
          'j.smith@example.com',
        ]
        expect {
          scope.function_govuk_check_user_naming(args)
        }.to raise_error(Puppet::Error, /username 'jsmith' to be 'johnsmith' based on fullname/)
      end
    end

    describe 'username does not match email' do
      it 'should raise an exception' do
        args = [
          'jsmith',
          'J Smith',
          'john.smith@example.com',
        ]
        expect {
          scope.function_govuk_check_user_naming(args)
        }.to raise_error(Puppet::Error, /username 'jsmith' to be 'johnsmith' based on email/)
      end
    end
  end

  describe 'valid' do
    describe 'username matches fullname and email' do
      it 'should not raise an exception' do
        args = [
          'johnsmith',
          'John Smith',
          'john.smith@example.com',
        ]
        expect {
          scope.function_govuk_check_user_naming(args)
        }.not_to raise_error
      end
    end

    describe 'name contains more than two parts' do
      it 'should not raise an exception' do
        args = [
          'johndoesmith',
          'John Doe Smith',
          'john.doe.smith@example.com',
        ]
        expect {
          scope.function_govuk_check_user_naming(args)
        }.not_to raise_error
      end
    end

    describe 'fullname and email contain non-alpha characters' do
      it 'should match without non-alpha chars and not raise an exception' do
        args = [
          'johnosmithjones',
          'John O\'Smith-Jones',
          'john.osmith-jones@example.com',
        ]
        expect {
          scope.function_govuk_check_user_naming(args)
        }.not_to raise_error
      end
    end
  end
end
