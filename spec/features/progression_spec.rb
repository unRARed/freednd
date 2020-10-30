require 'rails_helper'

RSpec.feature "Progressions", type: :feature do
  scenario 'to PDF asset' do
    user = create :user
    campaign = create :campaign
    party = create :party, campaign: campaign
    character = create :character, :with_rp_content, user: user
    progression = create :progression, character: character
    pdf = ProgressionSheet.new(progression)

    parsed_pdf = PDF::Inspector::Page.analyze(pdf.render)
    expect(parsed_pdf.pages.size).to eq(2)

    # Front page containts static and calculated stats/info
    front_content = parsed_pdf.pages.first[:strings]
    expect(front_content).to include(character.name)
    expect(front_content).to include(character.race)
    expect(front_content).to include(character.dnd_class)
    expect(front_content).to include(character.speed.to_s)

    # All skill names should appear
    Skill.names.keys.each{ |k| expect(front_content.to_s).to include(k) }

    expect(front_content).to include(progression.level.to_s)
    expect(front_content).to include(progression.hit_points_max.to_s)
    expect(front_content).to include(progression.armor_class.to_s)
    expect(front_content).to include("+#{progression.proficiency_bonus}")

    # Back page contains the Role Playing info
    back_content = parsed_pdf.pages.last[:strings]
    expect(back_content).to include(strip_both(character.appearance))
    expect(back_content).to include(strip_both(character.backstory))
    expect(back_content).to include(strip_both(character.personality))
    expect(back_content).to include(strip_both(character.ideals))
    expect(back_content).to include(strip_both(character.bonds))
    expect(back_content).to include(strip_both(character.flaws))
    expect(back_content).to include(strip_both(character.other_traits))
  end

private

  def strip_both(value)
    ActionController::Base.helpers.strip_tags(value.to_s).strip
  end
end
