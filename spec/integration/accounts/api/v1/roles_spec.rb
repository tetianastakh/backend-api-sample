require 'swagger_helper'

describe 'Roles API' do
  let(:company) { create(:company) }
  let(:permissions) { create_list(:permission, 1, name: :write_roles) }
  let(:role) { create(:role, company: company, permissions: permissions) }
  let(:user) { create(:client_user, company: company, company_role: role) }
  let(:Authorization) { "Bearer #{user.tokens.create.token}" }

  path '/accounts/api/v1/roles/{id}' do
    get 'Retrieves a role' do
      tags 'Roles'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer {token}'
      parameter name: :id, in: :path, type: :string

      let!(:id) { create(:role, company_id: company.id).id }

      response '200', 'role found' do
        schema type: :object, required: %i[id name], properties: {
          id: { type: :string, example: '2b5bj7e2-049e-11ea-9213-f7736ce396e5' },
          name: { type: :string, example: 'Manager' },
          permissions: {
            type: :array,
            items: { '$ref' => '#/definitions/permission' }
          }
        }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { '' }

        run_test!
      end

      response '403', 'Forbidden' do
        let(:user) { create(:client_user, company: company) }

        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { '123' }

        run_test!
      end
    end

    put 'Updates role' do
      tags 'Roles'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer {token}'
      parameter name: :id, in: :path, type: :string
      parameter name: :body, in: :body, description: 'Passing empty array of permission_ids will removes all permissions from role, vice versa,
      it assigns permissions with passed ids to role', schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            required: %i[id name], properties: {
              name: { type: :string, example: 'Manager' },
              permission_ids: {
                type: :array,
                description: "Only able to assign permissions ids which are enabled by your company",
                items: {
                  type: :string, format: :uuid, example: 'b899d8e6b76a-eb4d-11e9-48c69b72-b6bd'
                }
              }
            }
          }
        }
      }

      let(:id) { create(:role, company_id: company.id).id }
      let(:body) do
        {
          role: { name: 'Updated' }
        }
      end

      response '200', 'Success' do
        schema type: :object, properties: {
          id: { type: :string, example: '2b5bj7e2-049e-11ea-9213-f7736ce396e5' },
          name: { type: :string, example: 'Manager' }
        }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { '' }

        run_test!
      end

      response '403', 'Forbidden' do
        let(:user) { create(:client_user, company: company) }

        run_test!
      end

      response '422', 'Unprocessable Entity' do
        let(:body) do
          {
            role: { name: nil }
          }
        end

        run_test!
      end
    end

    delete 'Deletes a role' do
      tags 'Roles'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer {token}'
      parameter name: :id, in: :path, required: true, type: :string

      let(:id) { create(:role, company: company).id }

      response '204', 'role deleted' do
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { '' }

        run_test!
      end

      response '403', 'Forbidden' do
        let(:user) { create(:client_user, company: company) }

        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { '123' }

        run_test!
      end
    end
  end

  path '/accounts/api/v1/roles' do
    get 'Retrieves a list of roles' do
      tags 'Roles'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer {token}'
      parameter name: :company_id, in: :query, type: :string, description: 'Admin only. company id to fetch roles. For company member this param is not used, company_id fetches from current users\'s company'

      let(:company_id) { company.id }

      response '200', 'list of roles' do
        schema type: :array, items: { '$ref' => '#/definitions/role' }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { '' }

        run_test!
      end

      response '403', 'Forbidden' do
        let(:user) { create(:client_user, company: company) }

        run_test!
      end
    end

    post 'Creates a role' do
      tags 'Roles'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer {token}'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          role: {
            type: :object,
            required: %i[name],
            properties: {
              name: { type: :string, example: 'Manager' },
              company_id: {
                type: :string,
                format: 'uuid',
                example: '719c8bae-ef55-11e9-9550-5746ad3d72f6',
                description: 'Requred for admin. For company member this param is not used, company_id fetches from current users\'s company'
              },
              permission_ids: {
                type: :array,
                description: "Only able to assign permissions ids which are enabled by your company",
                items: {
                  type: :string, format: :uuid, example: 'b899d8e6b76a-eb4d-11e9-48c69b72-b6bd'
                }
              }
            }
          }
        }
      }

      let(:body) do
        {
          role: {
            name: 'manage_accounts',
            company_id: company.id
          }
        }
      end

      response '200', 'Success' do
        schema type: :object, properties: {
          id: { type: :string, example: '2b5bj7e2-049e-11ea-9213-f7736ce396e5' },
          name: { type: :string, example: 'Manager' }
        }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { '' }

        run_test!
      end

      response '403', 'Forbidden' do
        let(:user) { create(:client_user, company: company) }

        run_test!
      end

      response '422', 'Unprocessable Entity' do
      let(:body) do
        {
          role: { name: nil }
        }
      end

        run_test!
      end
    end
  end
end
