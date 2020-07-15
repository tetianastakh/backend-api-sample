require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relationships' do
    it { should have_one(:company_user) }
    it { should have_one(:company).through(:company_user) }
    it { should belong_to(:company_role) }
    it { should have_many(:permissions).through(:company_role) }
    it { should accept_nested_attributes_for(:company_user) }
  end

  describe 'validations' do
    context 'role_belongs_to_company' do
      let(:company) { create(:company) }

      context 'when role has same company id' do
        subject { build(:client_user, company: company, company_role: build(:role, company: company)) }

        it { should be_valid }
      end

      context 'when role does not have same company id' do
        subject { build(:client_user, company: company, company_role: build(:role)) }

        it { should_not be_valid }
      end
    end
  end

  it_behaves_like 'a model which tracks changes' do
    subject { create(:client_user) }
    let(:changes) do
      {
        first_name: 'new first name',
        last_name: 'new last name'
      }
    end
  end
end
