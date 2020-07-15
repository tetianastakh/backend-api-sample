require 'rails_helper'


RSpec.describe ::Accounts::Roles::FetchService do
  describe 'perform' do
    let(:role) { create(:role, company: company) }
    let(:company) { create(:company) }
    let(:user) { create(:user_base, company: company) }

    subject { described_class.perform(user, role) }

    context 'when user belongs to company' do
      it 'returns user' do
        expect(subject).to eq(role)
      end
    end
  end
end

