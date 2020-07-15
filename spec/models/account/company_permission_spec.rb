require 'rails_helper'

RSpec.describe ::Account::CompanyPermission, type: :model do
  describe 'relationships' do
    it { should belong_to(:permission) }
    it { should belong_to(:company) }
  end

  describe 'callbacks' do
    context 'before_destroy remove_from_roles' do
      it 'should remove permission from role when deleted' do
        permissions  = create_list(:permission, 2)
        company = create(:company)
        role         = create(:role, company: company, permissions: permissions)

        expect(role.permissions.count).to eq(2)
        expect(company.permissions.count).to eq(2)

        company.company_permissions.first.destroy!

        expect(role.reload.permissions.count).to eq(1)
        expect(company.reload.permissions.count).to eq(1)
      end
    end
  end
end
