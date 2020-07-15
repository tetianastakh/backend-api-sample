require 'rails_helper'

RSpec.describe ::Accounts::Users::Detailed::Aggregate do
  describe 'initialize' do
    let(:user) { build_stubbed(:client_user) }

    subject { described_class.new(user) }

    it 'should have the expected fields' do
      result = subject

      expect(result.to_h.keys).to include(*expected_keys)
    end
  end

  private

  def expected_keys
    %i(
      id
      first_name
      last_name
      phone_number
      email
      role
      created_at
      updated_at
      confirmed
    )
  end
end
