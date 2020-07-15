require 'rails_helper'

RSpec.describe ::Account::companyUser, type: :model do
  describe 'relationships' do
    it { should belong_to(:company) }
    it { should belong_to(:user) }
  end

  it_behaves_like 'a model which tracks changes' do
    let(:company_user) { create(:company_user) }
    subject { company_user }
    let(:changes) do
      {
        user_id: create(:client_user).id
      }
    end
  end
end
