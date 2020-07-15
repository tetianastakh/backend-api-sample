require 'rails_helper'

RSpec.describe ::Account::Role, type: :model do
  describe 'relationships' do
    it { should have_many(:users) }
    it { should have_many(:permissions).through(:role_permissions) }
    it { should belong_to(:company) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  it_behaves_like 'a model which tracks changes' do
    let(:role) { create(:role) }
    subject { role }
    let(:changes) do
      {
        name: "_#{role.name}_"
      }
    end
  end
end
