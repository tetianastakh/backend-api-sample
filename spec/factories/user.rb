FactoryBot.define do
  factory :user_base, class: User do
    email { Faker::Internet.email }
    first_name { 'Test' }
    last_name { 'User' }
    password { 'qwerty' }
    phone_number { '123-456-789' }
    confirmed { true }
  end

  factory :random_user, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    role { User.roles[:is_client] }
    password { 'asdfasdf' }
    confirmed { true }
  end

  factory :admin_user, parent: :user_base do
    role { :is_admin }
    association :company

    after(:build) do |user|
      if user.company_role.nil?
        permissions = Account::Permission.where(name: [:manage_users])
        permissions = [
          build(:permission, name: :manage_users)
        ] if permissions.empty?

        user.company_role = build(:role, permissions: permissions, company: user.company)
      end
    end
  end

  factory :client_user, parent: :user_base do
    role { :is_client }
  end
end
