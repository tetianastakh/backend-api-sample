require 'rails_helper'

RSpec.describe ::Account::Company, type: :model do
  describe 'relationships' do
    it { should have_many(:company_users) }
    it { should have_many(:users).through(:company_users) }
    it { should have_many(:company_permissions) }
    it { should have_many(:permissions).through(:company_permissions) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  it_behaves_like 'a model with an associated image' do
    subject { create(:company) }
    let(:association_name) { :logo }
  end

  it_behaves_like 'a model which tracks changes' do
    let(:company) { create(:company) }
    subject { company }
    let(:changes) do
      {
        name: "_#{company.name}_"
      }
    end
  end
end
