class ProgressionSheet < Prawn::Document
  include CharactersHelper

  def initialize(progression = Progression.new)
    super(
      :page_size => 'LETTER',
      :page_layout => :portrait,
      :compress => true,
      :margin => 30
    )
    @progression = progression
    font "Times-Roman"
    font_size 13
    #text bounds.width.to_s (540)
    #text bounds.height.to_s (720)

    compile_front_page
    compile_back_page
  end

  def compile_front_page
    append_background("#{Rails.root}/app/assets/images/character-sheet.png")
    append_character_content
    append_abilities
    append_ability_mods
    append_saving_throws
    append_skills
    append_features
    append_wallet
    append_equipment
    append_inventory
    append_spellcasting
    append_avatar
  end

  def compile_back_page
    start_new_page
    append_background(
      "#{Rails.root}/app/assets/images/character-sheet-back.png"
    )
    append_appearance
    append_backstory
    append_personality
    append_ideals
    append_bonds
    append_flaws
    append_other_traits
  end

private

  def append_background(path)
    float do
      image path,
        width: bounds.width
    end
  end

  def append_appearance
    float do
      font_size 9
      bounding_box([17, from_top(27)], width: 520, height: 38) do
        text_box ActionController::Base.helpers.strip_tags(
          @progression.character.appearance.to_s
        ), :overflow => :shrink_to_fit
      end
    end
  end

  def append_backstory
    float do
      font_size 9
      bounding_box([17, from_top(95)], width: 520, height: 110) do
        text_box ActionController::Base.helpers.strip_tags(
          @progression.character.backstory.to_s
        ), :overflow => :shrink_to_fit
      end
    end
  end

  def append_personality
    float do
      font_size 9
      bounding_box([17, from_top(236)], width: 246, height: 146) do
        text_box ActionController::Base.helpers.strip_tags(
          @progression.character.personality.to_s
        ), :overflow => :shrink_to_fit
      end
    end
  end

  def append_ideals
    float do
      font_size 9
      bounding_box([292, from_top(236)], width: 246, height: 146) do
        text_box ActionController::Base.helpers.strip_tags(
          @progression.character.ideals.to_s
        ), :overflow => :shrink_to_fit
      end
    end
  end

  def append_bonds
    float do
      font_size 9
      bounding_box([17, from_top(410)], width: 246, height: 146) do
        text_box ActionController::Base.helpers.strip_tags(
          @progression.character.bonds.to_s
        ), :overflow => :shrink_to_fit
      end
    end
  end

  def append_flaws
    float do
      font_size 9
      bounding_box([292, from_top(410)], width: 246, height: 146) do
        text_box ActionController::Base.helpers.strip_tags(
          @progression.character.flaws.to_s
        ), :overflow => :shrink_to_fit
      end
    end
  end

  def append_other_traits
    float do
      font_size 9
      bounding_box([17, from_top(588)], width: 520, height: 120) do
        text_box ActionController::Base.helpers.strip_tags(
          @progression.character.other_traits.to_s
        ), :overflow => :shrink_to_fit
      end
    end
  end

  def append_character_content
    float do
      #############
      ## 1st Row ##
      #############
      # NAME
      bounding_box([15, from_top(18)], width: 150, height: 13) do
        text_box @progression.character.name,
          :overflow => :shrink_to_fit
      end
      # RACE
      bounding_box([196, from_top(18)], width: 170, height: 13) do
        text @progression.character.race
      end
      # LEVEL
      bounding_box([396, from_top(18)], width: 45, height: 13) do
        text @progression.level.to_s
      end

      #############
      ## 2nd Row ##
      #############
      # SPEED
      bounding_box([126, from_top(55)], width: 50, height: 13) do
        text @progression.character.speed.to_s
      end
      # Hitpoints MAX
      bounding_box([66, from_top(55)], width: 40, height: 13) do
        text @progression.hit_points_max.to_s
      end
      # Class
      bounding_box([196, from_top(55)], width: 170, height: 13) do
        text @progression.character.dnd_class
      end
      # Prof Bonus
      bounding_box([396, from_top(55)], width: 50, height: 13) do
        text @progression.proficiency_bonus.to_s
      end
    end
  end

  def append_abilities
    float do
      # STRENGTH
      bounding_box([34, from_top(121)], width: 45, height: 13) do
        text pad_int(@progression.strength), color: 'ffffff'
      end
      # DEXTERITY
      bounding_box([35, from_top(201)], width: 45, height: 13) do
        text pad_int(@progression.dexterity), color: 'ffffff'
      end
      # CONSTITUTION
      bounding_box([41, from_top(322)], width: 45, height: 13) do
        text pad_int(@progression.constitution), color: 'ffffff'
      end
      # INTELLIGENCE
      bounding_box([218, from_top(121)], width: 45, height: 13) do
        text pad_int(@progression.intelligence), color: 'ffffff'
      end
      # WISDOM
      bounding_box([219, from_top(241)], width: 45, height: 13) do
        text pad_int(@progression.wisdom), color: 'ffffff'
      end
      # CHARISMA
      bounding_box([218, from_top(363)], width: 45, height: 13) do
        text pad_int(@progression.charisma), color: 'ffffff'
      end
    end
  end

  def append_ability_mods
    float do
      font_size 10
      # STRENGTH MOD
      bounding_box([18, from_top(105)], width: 45, height: 13) do
        text format_modifier(@progression.strength_mod)
      end
      # DEXTERITY MOD
      bounding_box([19, from_top(185)], width: 45, height: 13) do
        text format_modifier(@progression.dexterity_mod)
      end
      # CONSTITUTION MOD
      bounding_box([25, from_top(306)], width: 45, height: 13) do
        text format_modifier(@progression.constitution_mod)
      end
      # INTELLIGENCE MOD
      bounding_box([202, from_top(105)], width: 45, height: 13) do
        text format_modifier(@progression.intelligence_mod)
      end
      # WISDOM MOD
      bounding_box([203, from_top(225)], width: 45, height: 13) do
        text format_modifier(@progression.wisdom_mod)
      end
      # CHARISMA MOD
      bounding_box([202, from_top(348)], width: 45, height: 13) do
        text format_modifier(@progression.charisma_mod)
      end
    end
  end

  def append_saving_throws
    float do
      font_size 10
      # STRENGTH MOD
      bounding_box([156, from_top(142)], width: 45, height: 13) do
        text format_modifier(
          @progression.saving_throw_bonus(:strength)
        )
      end
      # DEXTERITY MOD
      bounding_box([156, from_top(274)], width: 45, height: 13) do
        text format_modifier(
          @progression.saving_throw_bonus(:dexterity)
        )
      end
      # CONSTITUTION MOD
      bounding_box([73, from_top(356)], width: 45, height: 13) do
        text format_modifier(
          @progression.saving_throw_bonus(:constitution)
        )
      end
      # INTELLIGENCE MOD
      bounding_box([356, from_top(182)], width: 45, height: 13) do
        text format_modifier(
          @progression.saving_throw_bonus(:intelligence)
        )
      end
      # WISDOM MOD
      bounding_box([356, from_top(302)], width: 45, height: 13) do
        text format_modifier(
          @progression.saving_throw_bonus(:wisdom)
        )
      end
      # CHARISMA MOD
      bounding_box([356, from_top(431)], width: 45, height: 13) do
        text format_modifier(
          @progression.saving_throw_bonus(:charisma)
        )
      end
    end
  end

  def append_skills
    float do
      # STRENGTH
      bounding_box([63, from_top(101)], width: 106, height: 30) do
        Character::SKILLS[:strength].each do |skill_target|
          @progression.skills.each do |skill|
            next unless skill_target == skill.name
            text "#{skill.name}: #{format_modifier(skill.value)}"
          end
        end
      end
    end
    float do
      # DEXTERITY
      bounding_box([65, from_top(181)], width: 106, height: 72) do
        Character::SKILLS[:dexterity].each do |skill_target|
          @progression.skills.each do |skill|
            next unless skill_target == skill.name
            text "#{skill.name}: #{format_modifier(skill.value)}"
          end
        end
      end
    end
    float do
      # INTELLIGENCE
      bounding_box([248, from_top(101)], width: 124, height: 70) do
        Character::SKILLS[:intelligence].each do |skill_target|
          @progression.skills.each do |skill|
            next unless skill_target == skill.name
            text "#{skill.name}: #{format_modifier(skill.value)}"
          end
        end
      end
    end
    float do
      # WISDOM
      bounding_box([249, from_top(221)], width: 124, height: 70) do
        Character::SKILLS[:wisdom].each do |skill_target|
          @progression.skills.each do |skill|
            next unless skill_target == skill.name
            text "#{skill.name}: #{format_modifier(skill.value)}"
          end
        end
      end
    end
    float do
      # CHARISMA
      bounding_box([248, from_top(343)], width: 124, height: 70) do
        Character::SKILLS[:charisma].each do |skill_target|
          @progression.skills.each do |skill|
            next unless skill_target == skill.name
            text "#{skill.name}: #{format_modifier(skill.value)}"
          end
        end
      end
    end
  end

  def append_equipment
    float do
      font_size 8
      bounding_box([16, from_top(474)], width: 156, height: 230) do
        @progression.equipment.each do |item|
          text "#{item.quantity.to_s + 'x ' if item.quantity} #{item.
          dnd_equipment.name}"
        end
      end
    end
  end

  def append_inventory
    float do
      font_size 6
      bounding_box([197, from_top(474)], width: 176, height: 230) do
        text_box ActionController::Base.helpers.strip_tags(
          @progression.inventory.to_s
        ), :overflow => :shrink_to_fit
      end
    end
  end

  def append_wallet
    float do
      font_size 7
      bounding_box([45, from_top(402)], width: 30, height: 13) do
        text @progression.wallet[:copper].to_s
      end
      bounding_box([72, from_top(402)], width: 30, height: 13) do
        text @progression.wallet[:silver].to_s
      end
      bounding_box([19, from_top(426)], width: 30, height: 13) do
        text @progression.wallet[:electrum].to_s
      end
      bounding_box([45, from_top(426)], width: 30, height: 13) do
        text @progression.wallet[:gold].to_s
      end
      bounding_box([72, from_top(426)], width: 30, height: 13) do
        text @progression.wallet[:platinum].to_s
      end
    end
  end

  def append_features
    float do
      font_size 8
      bounding_box([396, from_top(100)], width: 138, height: 210) do
        @progression.dnd_features.each do |feature|
          text feature.name
        end
      end
    end
  end

  def append_spellcasting
    float do
      font_size 13
      # Spell Save DC
      bounding_box([422, from_top(342)], width: 45, height: 13) do
        text @progression.spell_save_dc.to_s
      end
      # Spell Attack Bonus
      bounding_box([496, from_top(342)], width: 45, height: 13) do
        text format_modifier(@progression.spell_attack_bonus)
      end
      font_size 9
      bounding_box([400, from_top(390)], width: 130, height: 316) do
        @progression.dnd_spells.each do |spell|
          text spell.formatted_name
        end
        if @progression.dnd_spells.any? && @progression.dnd_cantrips.any?
          text "\n"
          text "CANTRIPS:"
        end
        @progression.dnd_cantrips.each do |spell|
          text spell.name
        end
      end
    end
  end

  def append_avatar
    avatar = @progression.character.avatar
    return unless avatar.attached?
    float do
      bounding_box([100, from_top(316)], width: 80, height: 130) do
        ###########data = StringIO.new(portrait.blob.download)
        # Can't figure out how to get the Variant (avatar_portrait)
        # from ActiveStorage. This might be a new feature coming
        # in Rails 6.1: "config.active_storage.track_variants"
        #
        # So we duplicate the processing here:
        variant = MiniMagick::Image.open helpers.url_for(avatar)
        variant.combine_options do |img|
          img.resize '480x720^'
          img.gravity 'center'
          img.extent '480x720'
          img.colorspace 'Gray'
        end
        image variant.path, width: 80
      end
    end
  end

  # bounding_box from BOTTOM-LEFT,
  # so make it easier to reason about
  def from_top(value)
    bounds.height - value
  end

  def pad_int(value)
    return '' unless value
    "%02d" % value
  end

  def helpers
    Rails.application.routes.url_helpers
  end
end
