require 'rails_helper'


RSpec.describe ::Accounts::Roles::UpdateService do
  describe 'perform' do
    let(:permission) { create(:permission) }
    let(:company) do
      create(:company).tap do |org|
        org.permissions.concat(permission)
      end
    end
    let(:role) { create(:role, company: company) }
    let(:user) { create(:user_base, company: company) }

    subject { described_class.perform(user, role.id, role_params) }

    context 'when params are valid' do
      let(:role_params) { { name: 'Updated' } }

      it 'updates role' do
        expect(subject.name).to eq(role_params[:name])
      end
    end

    context 'when params are not valid' do
      let(:role_params) { { name: nil } }

      it 'returns 422 Unpocessible Entity' do
        expect { subject }.to raise_error(::Exceptions::UnableToUpdate)
      end
    end

    context 'when permission_ids in params includes array of values' do
      let(:role_params) { { permission_ids: [permission.id] } }

      it 'creates role permission in db' do
        expect { subject }.to change { Account::RolePermission.count }.by(1)

        expect(role.reload.permissions).to eq([permission])
      end
    end

    context 'when permission_ids in params is empty array' do
      let!(:role_permission) { create(:role_permission, role: role, permission: permission) }
      let(:role_params) { { permission_ids: [] } }

      it 'deletes role permission from db' do
        expect { subject }.to change { Account::RolePermission.count }.by -1
      end

      it 'removes permission from role' do
        subject

        expect(role.permissions).to eq([])
      end
    end
  end
end
