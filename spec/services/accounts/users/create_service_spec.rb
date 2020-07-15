require 'rails_helper'


RSpec.describe ::Accounts::Users::CreateService do
  describe 'perform' do
    let(:admin) { create(:admin_user) }
    let(:user) { create(:client_user, company: company) }
    let(:company) { create(:company) }
    let(:role) { create(:role, company: company) }
    let(:user_params) do
      {
        email: Faker::Internet.email,
        first_name: Faker::Name.unique.name,
        last_name: Faker::Name.unique.name,
        phone_number: Faker::PhoneNumber.phone_number,
        role_id: role.id,
        password: '111111',
        company_id: company.id
      }
    end

    subject { described_class.perform(user, user_params) }

    context 'when params are valid' do
      it 'creates user with expected properties' do
        user = subject

        expect(user.email).to eq(user_params[:email])
        expect(user.phone_number).to eq(user_params[:phone_number])
        expect(user.first_name).to eq(user_params[:first_name])
        expect(user.last_name).to eq(user_params[:last_name])
        expect(user.role_id).to eq(user_params[:role_id])
        expect(user.company.id).to eq(company.id)
        expect(user.role).to eq('is_client')
      end
    end

    context 'params are not valid' do
      subject { described_class.perform(user, {}) }

      it 'returns 422 Unpocessible Entity' do
        expect { subject }.to raise_error(::Exceptions::UnableToCreate)
      end
    end

    context 'current user is admin' do
      subject { described_class.perform(admin, user_params) }

      it 'creates user for specified company' do
        expect(subject.company.id).to eq(company.id)
      end

      context 'when company doesn\'t exist' do
        subject { described_class.perform(admin, user_params) }

        it 'returns 404 Not Found' do
          user_params[:company_id] = 999_999_999

          expect { subject }.to raise_error(::Exceptions::RecordNotFound)
        end
      end
    end
  end
end
