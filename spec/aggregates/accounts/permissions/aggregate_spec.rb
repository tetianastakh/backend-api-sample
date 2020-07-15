require 'rails_helper'

RSpec.describe ::Accounts::Permissions::Aggregate do
  describe 'initialize' do
    let(:permission) { build_stubbed(:permission) }
    properties = [
      :id,
      :name
    ]

    subject { ::Accounts::Permissions::Aggregate.new(permission) }

    properties.each do |key|
      it "should have #{key} key" do
        expect(subject.to_h.keys).to include(key)
      end
    end
  end
end
