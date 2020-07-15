require 'rails_helper'


RSpec.describe ::Accounts::Roles::CreateService do
  describe 'perform' do
    let(:company) { create(:company) }
    let(:user) { create(:user_base, company: company) }
    let(:role_params) do
      {
        name: 'Test'
      }
    end

    subject { described_class.perform(user, role_params) }

    context 'when params are valid' do
      it 'creates role with specified name' do
        expect(subject.name).to eq(role_params[:name])
      end
    end

    context 'params are not valid' do
      subject { described_class.perform(user, {}) }

      it 'returns 422 Unpocessible Entity' do
        expect { subject }.to raise_error(::Exceptions::UnableToCreate)
      end
    end
  end
end

