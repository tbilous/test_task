FactoryGirl.define do
  factory :task do
    title Faker::FamilyGuy.character
    body Faker::Address.city
    task_type %i(bug_fix code test).sample
  end
end
