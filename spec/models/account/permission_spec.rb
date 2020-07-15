require 'rails_helper'

RSpec.describe ::Account::Permission, type: :model do
  describe 'relationships' do
    it { should have_many(:roles).through(:role_permissions) }
    it { should have_many(:company_permissions) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  it_behaves_like 'a model which tracks changes' do
    let(:permission) { create(:permission) }
    subject { permission }
    let(:changes) do
      {
        name: "_#{permission.name}_"
      }
    end
  end
end
