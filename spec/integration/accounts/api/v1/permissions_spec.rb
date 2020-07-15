require 'swagger_helper'

describe 'Permissions API' do
  let(:company) { create(:company) }
  let(:permissions) { create_list(:permission, 1, name: :read_permissions) }
  let(:role) { create(:role, company: company, permissions: permissions) }
  let(:user) { create(:client_user, company: company, company_role: role) }
  let(:Authorization) { "Bearer #{user.tokens.create.token}" }

  path '/accounts/api/v1/permissions' do
    get 'Retrieves a list of permissions' do
      description "To view all permissions, users must have the `manage_users` permission. " \
        "Otherwise the endpoint will return permissions enabled for you company "
      tags 'Permissions'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer {token}'

      response '200', 'list of permissions' do
        schema type: :array, items: { '$ref' => '#/definitions/permission' }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { '' }

        run_test!
      end

      response '403', 'Forbidden' do
        let(:user) { create(:client_user) }

        run_test!
      end
    end
  end
end
