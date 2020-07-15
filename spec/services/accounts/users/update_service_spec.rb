require 'rails_helper'


RSpec.describe ::Accounts::Users::UpdateService do
  describe 'perform' do
    let(:user) { create(:client_user, company: company) }
    let(:other_user) { create(:client_user, company: company) }
    let(:company) { create(:company) }
    let(:role) {create(:role, company: company) }
    let(:user_params) do
      {
        email: Faker::Internet.email,
        first_name: Faker::Name.unique.name,
        last_name: Faker::Name.unique.name,
        phone_number: Faker::PhoneNumber.phone_number,
        role_id: role.id,
        password: '111111'
      }
    end

    subject { described_class.perform(user, other_user.id, user_params) }

    context 'when params are valid' do
      let(:user_params) { { email: 'new_email@test.com' } }

      it 'updates user' do
        expect(subject.email).to eq(user_params[:email])
      end
    end

    context 'when params are not valid' do
      let(:user_params) { { email: nil } }

      it 'returns 422 Unpocessible Entity' do
        expect { subject }.to raise_error(::Exceptions::UnableToUpdate)
      end
    end

    context 'when user not belong to the company' do
      let(:user) { create(:client_user) }

      it 'should return 404 Not Found' do
        expect { subject }.to raise_error(::Exceptions::RecordNotFound)
      end
    end
  end
end

