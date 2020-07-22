FactoryBot.define do
  factory :progression do
    archetype { 'do we need this?' }
    explicit_level { nil }
    experience { 100 }
    hit_points { 10 }
    hit_points_max { 10 }
    inspiration { nil }
    strength { 10 }
    dexterity { 10 }
    constitution { 10 }
    intelligence { 10 }
    wisdom { 10 }
    charisma { 10 }

    character
    party
  end
end
