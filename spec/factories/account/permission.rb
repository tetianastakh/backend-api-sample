FactoryBot.define do
  factory :permission, class: ::Account::Permission do
    name { Faker::Lorem.unique.word.underscore }
    description { Faker::Lorem.sentence }
  end
end
