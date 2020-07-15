require 'rails_helper'

RSpec.describe ::Accounts::Roles::Aggregate do
  describe 'initialize' do
    let(:role) { build_stubbed(:role) }
    properties = [
      :id,
      :name
    ]

    subject { ::Accounts::Roles::Aggregate.new(role) }

    properties.each do |key|
      it "should have #{key} key" do
        expect(subject.to_h.keys).to include(key)
      end
    end

    context 'with show_permissions' do
      subject { described_class.new(role).show_permissions }

      it 'should have permissions key' do
        expect(subject.to_h.keys).to include(:permissions)
      end
    end
  end
end
