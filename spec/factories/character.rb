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

  trait :with_rp_content do
    appearance { 'Ridiculously good looking' }
    backstory { 'Father does not approve of his career choice.' }
    personality { 'Self-absorbed and dim-witted but good-natured.' }
    ideals { 'Only point to life is to be ridiculously good looking.' }
    bonds { 'Orange Mocha Frappuccinos' }
    flaws { 'Cannot turn left.' }
    other_traits { 'Blue Steel' }
  end
end
