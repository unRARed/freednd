FactoryBot.define do
  factory :character do
    name { 'Bilbo' }
    dnd_class { 'Bard' }
    race { 'Halfling' }
    background { 'Outlander' }
    alignment { 'Chaotic Good' }

    user
  end
end
