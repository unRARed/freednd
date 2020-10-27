FactoryBot.define do
  factory :character do
    name { 'Bilbo' }
    dnd_class { 'Bard' }
    race { 'Halfling' }
    background { 'Outlander' }
    alignment { 'Chaotic Good' }

    user
  end

  trait :bard do
    dnd_class { 'Bard' }
  end

  trait :fighter do
    dnd_class { 'Fighter' }
  end
end
