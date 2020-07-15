require 'rails_helper'


RSpec.describe ::Accounts::Users::FetchService do
  describe 'perform' do
    let(:user) { create(:client_user, company: company) }
    let(:other_user) { create(:client_user, company: company) }
    let(:company) { create(:company) }

    subject { described_class.perform(user, other_user.id) }

    context 'when user belongs to company' do
      it 'returns user' do
        expect(subject).to eq(other_user)
      end
    end

    context 'when user doesn\'t belong to company' do
      let(:user) { create(:client_user) }

      it 'returns 404 Not Found' do
        expect { subject }.to raise_error(::Exceptions::RecordNotFound)
      end
    end
  end
end

