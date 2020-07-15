require 'swagger_helper'

describe 'company Users API' do
  let(:company) { create(:company) }
  let(:company_id) { company.id }
  let(:permissions) { create_list(:permission, 1, name: :write_users) }
  let(:role) { create(:role, company: company, permissions: permissions) }
  let(:user) { create(:client_user, company: company, company_role: role) }
  let(:token) { create(:token, user: user) }
  let(:Authorization) { "Bearer #{token.token}" }

  path '/accounts/api/v1/users/{id}' do
    get 'Retrieves a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer {token}'
      parameter name: :id,            in: :path,   type: :string, required: true

      let(:id) { user.id }

      response '200', 'User found' do
        schema type: :object, properties: { '$ref' => '#/definitions/user' }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { '' }

        run_test!
      end

      response '403', 'Bad Permission' do
        let(:user) { create(:client_user, company: company) }

        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { '123' }

        run_test!
      end
    end

    put 'Updates user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :id,            in: :path,   type: :string, format: :uuid, required: true
      parameter name: :body,          in: :body,   schema: {
        type: :object,
        properties: {
          user: {
            type:       :object,
            required:   %i[id],
            properties: {
              email:           { type: :string, example: 'mail@test.com' },
              password:        { type: :string, writeOnly: true, example: '12345678' },
              first_name:      { type: :string, example: 'John' },
              last_name:       { type: :string, example: 'Doe' },
              phone_number:    { type: :string, example: '111-222-3333' },
              role:            { type: :string, example: 'is_admin', description: 'Defaults to `client_user`. Only available to users with `manage_accounts` permission' },
              role_id:         { type: :string, format: :uuid, example: '8773947a-014a-11ea-9139-3b890daee051', description: 'Only able to assign a role from your company' },
              company_id: { type: :string, format: :uuid, example: '719c8bae-ef55-11e9-9550-5746ad3d72f6', description: 'Only available to users with `manage_accounts` permission. To remove a user from an company, set this field to nil. When changing a users\' company, a `role_id` for the new company should be provided.' },
            }
          }
        }
      }

      let(:id) { user.id }
      let(:body) do
        {
          user: {
            first_name: 'Mark'
          }
        }
      end

      response '200', 'Success' do
        schema type: :object, properties: { '$ref' => '#/definitions/user' }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { '' }

        run_test!
      end

      response '403', 'Bad Permission' do
        let(:user) { create(:client_user, company: company) }

        run_test!
      end

      response '422', 'Unprocessable Entity' do
        let(:body) do
          {
            user: {
              email: nil
            }
          }
        end

        run_test!
      end
    end

    delete 'Deletes a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :id,            in: :path,   type: :string, required: true, format: :uuid

      let(:id) { user.id }

      response '204', 'user deleted' do
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { '' }

        run_test!
      end

      response '403', 'Bad Permission' do
        let(:user) { create(:client_user, company: company) }

        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { '123' }

        run_test!
      end
    end
  end

  path '/accounts/api/v1/users' do
    get 'Retrieves a list of users in scope of company' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization,   in: :header, type: :string
      parameter name: :company_id, in: :query,  type: :string, description: 'Admin only. company id to fetch users for. For company member this param is not used, company_id fetches from current users\'s company'

      response '200', 'List of users related to the company' do
        schema type: :array, properties: {
          user: {
            type:       :object,
            properties: {
              id:           { type: :string, example: '8773947a-014a-11ea-9139-3b890daee051', format: :uuid },
              first_name:   { type: :string, example: 'John' },
              last_name:    { type: :string, example: 'Doe' },
              user_code:    { type: :string, example: '111-222-3333' },
              email:        { type: :string, example: 'john@gmail.com' },
              phone_number: { type: :string, example: '+380 734181090' },
              role:         { type: :string, example: 'Manager' }
            }
          }
        }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { '' }

        run_test!
      end

      response '403', 'Bad Permission' do
        let(:user) { create(:client_user, company: company) }

        run_test!
      end
    end

    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type:       :object,
            required:   %i[first_name last_name email password role_id],
            properties: {
              email:           { type: :string, example: 'mail@test.com' },
              password:        { type: :string, writeOnly: true, example: '12345678' },
              first_name:      { type: :string, example: 'John' },
              last_name:       { type: :string, example: 'Doe' },
              phone_number:    { type: :string, example: '111-222-3333' },
              role:            { type: :string, example: 'is_admin', description: 'Defaults to `client_user`. Only available to users with `manage_accounts` permission' },
              role_id:         { type: :string, format: :uuid, example: '8773947a-014a-11ea-9139-3b890daee051', description: 'Only able to assign a role from your company' },
              company_id: { type: :string, format: :uuid, example: '719c8bae-ef55-11e9-9550-5746ad3d72f6', description: 'Requred for admin. For company member this param is not used, company_id fetches from current users\'s company' },
            }
          }
        }
      }

      let(:body) do
        {
          user: {
            first_name:      'John',
            last_name:       'Doe',
            email:           'test@secondcloset.com',
            password:        '11111111',
            company_id: company_id,
            role_id:         role.id
          }
        }
      end

      response '200', 'Success' do
        schema '$ref' => '#/definitions/user'
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { '' }

        run_test!
      end

      response '403', 'Bad Permission' do
        let(:user) { create(:client_user, company: company) }

        run_test!
      end

      response '422', 'Unprocessable Entity' do

        let(:body) do
          {
            user: {
              email:           nil,
              first_name:      'John',
              last_name:       'Doe',
              password:        '11111111',
              company_id: company_id,
              role_id:         role.id
            }
          }
        end

        run_test!
      end
    end
  end
end
