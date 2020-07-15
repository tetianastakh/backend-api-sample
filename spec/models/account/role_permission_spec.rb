require 'rails_helper'

RSpec.describe ::Account::RolePermission, type: :model do
  describe 'relationships' do
    it { should belong_to(:role) }
    it { should belong_to(:permission) }
  end

  describe 'validations' do
    context 'permission_is_enabled_for_company' do
      let(:company) { create(:company) }
      let(:role) { create(:role, company: company) }
      let(:permission) { create(:permission) }

      subject { build(:role_permission, role: role, permission: permission) }

      context 'when permission is enabled' do
        let(:company) do
          create(:company).tap do |org|
            org.permissions << permission
          end
        end

        it { should be_valid }
      end

      context 'when permission is not enabled' do
        it { should_not be_valid }
      end
    end
  end

  it_behaves_like 'a model which tracks changes' do
    let(:permission) { create(:permission) }
    let(:company) do
      create(:company).tap do |org|
        org.permissions << permission
      end
    end
    let(:role) { create(:role, company: company) }
    let(:role_permission) { create(:role_permission, role: role, permission: permission) }

    subject { role_permission }
    let(:changes) do
      {
        role_id: create(:role, company: company).id
      }
    end
  end
end
