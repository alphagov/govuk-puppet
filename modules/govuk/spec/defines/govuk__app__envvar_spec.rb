require_relative '../../../../spec_helper'

describe 'govuk::app::envvar', :type => :define do
  let(:title) { "robert-burns" }

  context 'with a value that has no newlines' do
    let(:params) {
      {
        :app => 'burns',
        :varname => 'GOVUK_POET_FULL_NAME',
        :value => 'Robert Burns'
      }
    }

    it "writes the value to disk" do
      is_expected.to contain_file('/etc/govuk/burns/env.d/GOVUK_POET_FULL_NAME')
                       .with_content('Robert Burns')
    end
  end

  context 'with a value that has newlines' do
    let(:params) {
      {
        :app => 'burns',
        :varname => 'GOVUK_TO_A_MOUSE',
        :value => to_a_mouse
      }
    }

    shared_examples_for 'a multiline env var' do
      it "writes the value to disk with null characters instead of newlines" do
        is_expected.to contain_file('/etc/govuk/burns/env.d/GOVUK_TO_A_MOUSE')
                         .with_content("Wee, sleekit, cowran, tim'rous beastie,\0O, what a panic's in thy breastie!\0Thou need na start awa sae hasty,\0Wi' bickering brattle!\0I wad be laith to rin an' chase thee,\0Wi' murd'ring pattle!\0")
      end
    end

    context 'that are normalized' do
      let(:to_a_mouse) {
        "Wee, sleekit, cowran, tim'rous beastie,
O, what a panic's in thy breastie!
Thou need na start awa sae hasty,
Wi' bickering brattle!
I wad be laith to rin an' chase thee,
Wi' murd'ring pattle!
"
      }

      it_behaves_like 'a multiline env var'
    end

    context 'that are excitingly diverse' do
      let(:to_a_mouse) {
        "Wee, sleekit, cowran, tim'rous beastie,\r\nO, what a panic's in thy breastie!\rThou need na start awa sae hasty,\nWi' bickering brattle!\nI wad be laith to rin an' chase thee,\r\nWi' murd'ring pattle!\r"
      }

      it_behaves_like 'a multiline env var'
    end
  end
end
