require 'rails_helper'


RSpec.describe ::Accounts::Roles::DestroyService do
  describe 'perform' do
    let!(:role) { create(:role) }

    context 'when there is role in db' do
      it 'deletes role from db' do
        expect { described_class.perform(role.id) }.to change { Account::Role.count }.by(-1)
      end
    end

    context 'when there is no role in db' do
      it 'responds with 404 not found' do
        expect { described_class.perform('1') }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end

