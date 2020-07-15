require 'swagger_helper'

describe 'companies API' do
  let(:company) { create(:company) }
  let(:id) { company.id }
  let(:permissions) { create_list(:permission, 1, name: :write_companies) }
  let(:role) { create(:role, company: company, permissions: permissions) }
  let(:user) { create(:client_user, company: company, company_role: role) }
  let(:Authorization) { "Bearer #{user.tokens.create.token}" }

  path '/accounts/api/v1/companies/{id}' do
    get 'Retrieves company' do
      tags 'companies'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer {token}'
      parameter name: :id,            in: :path,   type: :string

      response '200', 'company found' do
        schema type: :object, properties: { company: { '$ref' => '#/definitions/company' } }

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

      response '404', 'Not Found' do
        let(:id) { '123' }

        run_test!
      end
    end

    put 'Updates company' do
      tags 'companies'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer {token}'
      parameter name: :id,            in: :path,   type: :string, required: true
      parameter name: :body,          in: :body,   schema: {
        type: :object,
        properties: {
          company: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Second Closet' },
              permission_ids: {
                type: :array,
                items: {
                  type: :string, format: :uuid, example: 'b899d8e6b76a-eb4d-11e9-48c69b72-b6bd'
                }
              }
            }
          }
        }
      }

      response '200', 'Success' do
        schema type: :object, properties: { company: { '$ref' => '#/definitions/company' } }

        run_test!
      end

      response '403', 'Forbidden' do
        let(:user) { create(:client_user) }

        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { '123' }

        run_test!
      end

      response '422', 'Unprocessable Entity' do
        let(:body) do
          {
            company: {
              name: ''
            }
          }
        end

        run_test!
      end
    end
  end

  path '/accounts/api/v1/companies' do
    let(:permissions) { create_list(:permission, 1, name: :manage_accounts) }

    get 'Returns a list of companies' do
      tags 'companies'
      consumes 'application/json'
      produces 'application/json'
      description 'This endpoint is allowed only for admin users. When no search query is provided, endpoint will return 10 companies ordered by created_at date DESC.'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer {token}'
      parameter name: :q,             in: :query,  type: :string, description: 'Filter by search query, searches through company name', required: false
      parameter name: :page,          in: :query,  type: :integer, description: 'Specify page number', default: 1, required: false
      parameter name: :per_page,      in: :query,  type: :integer, description: 'Specify per page amount. If value is *ALL*, pagination skips and all items return', default: 10, required: false
      parameter name: :field,         in: :query,  type: :string, description: 'The desired field to be sorted. Default is *created_at*.', default: :created_at, required: false
      parameter name: :direction,     in: :query,  type: :string, description: 'The direction to be displayed. Options *ASC, DESC*.', default: :DESC, required: false

      response '200', 'Success' do
        schema type: :array, items: {
          type: :object, properties: {
            id:            { type: :string, example: 'c509044e-5ad1-11e8-8379-a35d72dd6eed' },
            name:          { type: :string, example: 'Second Closet' },
            email:         { type: [:string, :nil], example: 'mail@test.com' },
            phone_number:  { type: [:string, :nil], example: '111-222-3333' },
            created_at:    { type: :string, example: "2019-11-14T06:51:39.933-05:00" },
            users_amount:  { type: :integer, example: 8, description: 'amount of company\'s users' },
            orders_amount: { type: :integer, example: 18, description: 'amount of company\'s orders' }
          }
        }
        run_test!
      end

      response '403', 'Forbidden' do
        let(:user) { create(:client_user) }

        run_test!
      end
    end

    post 'Creates company' do
      tags 'companies'
      consumes 'application/json'
      produces 'application/json'
      description 'This endpoint is allowed only for admin users.'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer {token}'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          company: {
            type:       :object,
            required:   %i[name],
            properties: {
              name:         { type: :string, example: 'Second Closet' },
              email:        { type: :string, example: 'mail@test.com' },
              phone_number: { type: :string, example: '111-222-3333' },
              addresses_attributes: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    country:          { type: :string, example: 'Canada' },
                    city:             { type: :string, example: 'Toronto' },
                    address:          { type: :string, example: '1 Mayfair avenue' },
                    province:         { type: :string, example: 'ON' },
                    postal_code:      { type: :string, example: 'M5N 1NN' },
                    building_type:    { type: :string, example: 'is_apartment' },
                    elevator_access:  { type: :string, example: true },
                    apartment_number: { type: :string, example: '1' },
                    full_name:        { type: :string, example: 'John Doe' },
                    phone_number:     { type: :string, example: '111-111-3333' },
                    is_primary:       { type: :string, example: true },
                    status:           { type: :string, example: 'active' }
                  }
                }
              },
              logo_attributes: {
                type: :object,
                properties: {
                  file: { type: :string, format: :binary }
                }
              },
              user_ids: {
                type: :array,
                items: {
                  type: :string, format: :uuid, example: '48c69b72-eb4d-11e9-b6bd-b775d8e6b76a'
                }
              },
              permission_ids: {
                type: :array,
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
          company: {
            name: 'OrgName'
          }
        }
      end

      response '200', 'Success' do
        schema type: :object, properties: { company: { '$ref' => '#/definitions/company' } }

        run_test!
      end

      response '403', 'Forbidden' do
        let(:user) { create(:client_user) }

        run_test!
      end

      response '422', 'Unprocessable Entity' do
        let(:body) do
          {
            company: {
              name: nil
            }
          }
        end

        run_test!
      end
    end
  end
end
