require_relative '../../../../spec_helper'

describe 'statsd::counter', :type => :define do
  context "counter => giraffes.seen" do
    let(:title) {
      'giraffes.seen'
    }

    it {
      should contain_exec("statsd counter giraffes.seen").
        with_command(/giraffes\.seen:0|c/)
    }
  end
end
