require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.json' => {
      swagger: '2.0',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {
      },
      definitions: {
        ########################################################################
        # Accounts
        ########################################################################

        company: {
          type: :object,
          required: %i[id name],
          properties: {
            id:           { type: :string, example: '2b5bj7e2-049e-11ea-9213-f7736ce396e5' },
            name:         { type: :string, example: 'Second Closet' },
            phone_number: { type: [:string, :nil], example: '111-222-3333' },
            email:        { type: [:string, :nil], example: 'mail@test.com' },
            users: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id:         { type: :string, example: '2b5bd5e2-049e-11ea-9213-f7736ce396e5' },
                  first_name: { type: :string, example: 'Test' },
                  last_name:  { type: :string, example: 'User' }
                }
              }
            },
            permissions: {
              type: :array,
              items: { '$ref' => '#/definitions/permission' }
            }
          }
        },

        user: {
          type: :object,
          required: %i[id first_name last_name email],
          properties: {
            id:              { type: :string, example: '2b5bj7e2-049e-11ea-9213-f7736ce396e5' },
            email:           { type: :string, example: 'mail@test.com' },
            first_name:      { type: :string, example: 'John' },
            last_name:       { type: :string, example: 'Doe' },
            phone_number:    { type: [:string, :nil], example: '111-222-3333' },
            role_id:         { type: :string, format: :uuid, example: '8773947a-014a-11ea-9139-3b890daee051' }
          }
        },

        permission: {
          type: :object,
          required: %i[id name],
          properties: {
            id:   { type: :string, example: '2b5bd5e2-049e-11ea-9213-f7736ce396e5' },
            name: { type: :string, example: 'View Role Permissions List' }
          }
        },

        role: {
          type: :object,
          required: %i[id name],
          properties: {
            id:   { type: :string, example: '2b5bj7e2-049e-11ea-9213-f7736ce396e5' },
            name: { type: :string, example: 'Manager' },
            permissions: {
              type: :array,
              items: { '$ref' => '#/definitions/permission' }
            }
          }
        },

        fragment_user: {
          type: :object,
          properties: {
            id:         { type: :string, example: '2b5bd5e2-049e-11ea-9213-f7736ce396e5' },
            first_name: { type: :string, example: 'Test' },
            last_name:  { type: :string, example: 'User' },
            user_code:  { type: :string, example: 'TEUS' }
          }
        },

        error: {
          type: :object,
          properties: {
            ok:            { type: :boolean, example: false },
            status:        { type: :integer, example: 401 },
            error_message: { type: :string,  example: 'You need to authenticate.' }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :json
end
