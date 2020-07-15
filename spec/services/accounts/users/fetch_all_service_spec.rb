require 'rails_helper'


RSpec.describe ::Accounts::Users::FetchAllService do
  describe 'perform' do
    let(:user) { create(:client_user, company: company) }
    let(:other_user) { create(:client_user) }
    let(:company) { create(:company) }

    subject { described_class.perform(user) }

    context 'when user belongs to company' do

      it 'should be returned' do
        expect(subject).to include(user)
      end

    end

    context 'when user doesn\'t belong to company' do

      it 'should not be returned' do
        expect(subject).not_to include(other_user)
      end
      
    end
  end
end

