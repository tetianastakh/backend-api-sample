require 'rails_helper'

RSpec.describe Accounts::Api::V1::UsersController, type: :controller do
  render_views
  let(:parsed_body) { parse_body(response) }
  let(:company) { create(:company) }

  describe '#update' do
    let(:admin_user) { create(:admin_user) }
    let(:test_user) { create(:client_user, company: company) }
    let(:params) { { id: test_user.id, user: { first_name: 'new Name' } } }

    subject { put(:update, params: params, as: :json) }

    context 'authorization' do
      context 'when accessing user can `manage_accounts`' do
        before { set_request_authorization!(admin_user) }

        it 'should return success' do
          expect(subject).to be_successful
        end
      end

      context 'when accessing user has `write_users` permission' do
        let(:permissions) { create_list(:permission, 1, name: :write_users) }
        let(:role) { create(:role, company: company, permissions: permissions) }
        let(:client_user) { create(:client_user, company: company, company_role: role) }

        before { set_request_authorization!(client_user) }

        context 'and updates user with same company' do
          it 'should return success' do
            expect(subject).to be_successful
          end
        end

        context 'and updates user with a different company' do
          let(:test_user) { create(:client_user, :with_company) }

          it 'should return forbidden' do
            expect(subject).to have_http_status(:forbidden)
          end
        end
      end
    end

    context 'functionality' do
      before { set_request_authorization!(admin_user) }

      context 'updating role' do
        let(:permissions) { create_list(:permission, 1) }
        let(:role) { create(:role, company: company, permissions: permissions) }
        let(:params) { { id: test_user.id, user: { role_id: role.id } } }

        it 'should return success' do
          expect(test_user.role_id).to_not eq(role.id)

          expect(subject).to be_successful

          expect(test_user.reload.role_id).to eq(role.id)
        end

        context 'when role does not belong to company' do
          let(:role) { create(:role, permissions: permissions) }

          it 'should return unprocessable_entity' do
            expect(subject).to have_http_status(:unprocessable_entity)
          end
        end
      end

      context 'removing a user from an company' do
        let(:role) { create(:role, :with_permissions, company: company) }
        let(:test_user) { create(:client_user, company: company, company_role: role) }
        let(:params) { { id: test_user.id, user: { company_id: nil } } }

        it 'should remove role as well' do
          expect(test_user.company.id).to eq(company.id)
          expect(test_user.role_id).to eq(role.id)
          expect(test_user.role).to eq('is_client')

          expect(subject).to be_successful

          test_user.reload
          expect(test_user.role).to eq('is_client')
          expect(test_user.company_user).to eq(nil)
          expect(test_user.company).to eq(nil)
          expect(test_user.role_id).to eq(nil)
        end
      end

      context 'changing a user\'s company' do
        let(:existing_role) { create(:role, :with_permissions, company: company) }
        let(:test_user) { create(:client_user, company: company, company_role: existing_role) }
        let(:new_company) { create(:company) }
        let(:new_role) { create(:role, :with_permissions, company: new_company) }
        let(:role_id) { new_role.id }

        let(:params) { { id: test_user.id, user: { company_id: new_company.id, role_id: role_id } } }

        it 'should update company and role' do
          expect(test_user.company.id).to eq(company.id)
          expect(test_user.role_id).to eq(existing_role.id)
          expect(test_user.role).to eq('is_client')

          expect(subject).to be_successful

          test_user.reload
          expect(test_user.role).to eq('is_client')
          expect(test_user.company.id).to eq(new_company.id)
          expect(test_user.role_id).to eq(new_role.id)
        end

        context 'when new role_id is not passed' do
          let(:role_id) { nil }

          it 'should nullify role, and return success' do
            expect(test_user.company.id).to eq(company.id)
            expect(test_user.role_id).to eq(existing_role.id)
            expect(test_user.role).to eq('is_client')

            expect(subject).to be_successful

            test_user.reload
            expect(test_user.role).to eq('is_client')
            expect(test_user.company.id).to eq(new_company.id)
            expect(test_user.role_id).to eq(nil)
          end
        end

        context 'when new role_id does not belong to the new company' do
          let(:role_id) { existing_role.id }

          it 'should return 422' do
            expect(subject).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end
  end
end
