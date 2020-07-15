FactoryBot.define do
  factory :role, class: ::Account::Role do
    name { 'New' }

    association :company, factory: :company

    trait :with_permissions do
      after(:create) do |role|
        create_list(:permission, 3)
      end
    end

    after(:build) do |role, evaluator|
      role.company.permissions = role.company
        .permissions
        .to_a
        .concat(role.permissions).uniq do |p|
          p.name
        end
    end
  end
end
