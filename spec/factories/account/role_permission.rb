FactoryBot.define do
  factory :role_permission, class: ::Account::RolePermission do
    association :role, factory: :role
    association :permission, factory: :permission
  end
end
