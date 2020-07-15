require 'rails_helper'


RSpec.describe ::Accounts::Roles::FetchAllService do
  describe 'perform' do
    let(:role) { create(:role, company: company) }
    let(:company) { create(:company) }
    let(:user) { create(:user_base, company: company) }

    subject { described_class.perform(user) }

    context 'when role exists' do
      it 'should be returned' do
        expect(subject).to include(role)
      end
    end
  end
end

