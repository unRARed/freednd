FactoryBot.define do
  factory :campaign do
    name { 'Some Adventure' }
    description { 'It’s going to be a doozy!' }
    is_locked { false }

    user
  end
end
