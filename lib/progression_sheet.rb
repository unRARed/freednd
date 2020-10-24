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
    append_background
    font "Times-Roman"
    font_size 13
    #text bounds.width.to_s (540)
    #text bounds.height.to_s (720)

    append_character_content
    append_abilities
    append_ability_mods
    append_saving_throws
    append_equipment
    append_features
    append_spellcasting
    append_avatar
  end

  def append_background
    float do
      image "#{Rails.root}/app/assets/images/character-sheet.png",
        width: bounds.width
    end
  end

  def append_character_content
    float do
      #############
      ## 1st Row ##
      #############
      # NAME
      bounding_box([15, from_top(18)], width: 150, height: 13) do
        text @progression.character.name.truncate(24)
      end
      # RACE
      bounding_box([196, from_top(18)], width: 170, height: 13) do
        text @progression.character.race
      end
      # SPEED
      bounding_box([396, from_top(18)], width: 50, height: 13) do
        text @progression.character.speed.to_s
      end

      #############
      ## 2nd Row ##
      #############
      # LEVEL
      bounding_box([15, from_top(55)], width: 45, height: 13) do
        text @progression.level.to_s
      end
      # Hitpoints MAX
      bounding_box([130, from_top(55)], width: 40, height: 13) do
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
        text pad(@progression.strength), color: 'ffffff'
      end
      # DEXTERITY
      bounding_box([35, from_top(201)], width: 45, height: 13) do
        text pad(@progression.dexterity), color: 'ffffff'
      end
      # CONSTITUTION
      bounding_box([41, from_top(322)], width: 45, height: 13) do
        text pad(@progression.constitution), color: 'ffffff'
      end
      # INTELLIGENCE
      bounding_box([218, from_top(121)], width: 45, height: 13) do
        text pad(@progression.intelligence), color: 'ffffff'
      end
      # WISDOM
      bounding_box([219, from_top(241)], width: 45, height: 13) do
        text pad(@progression.wisdom), color: 'ffffff'
      end
      # CHARISMA
      bounding_box([218, from_top(363)], width: 45, height: 13) do
        text pad(@progression.charisma), color: 'ffffff'
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
      bounding_box([72, from_top(356)], width: 45, height: 13) do
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
      bounding_box([356, from_top(426)], width: 45, height: 13) do
        text format_modifier(
          @progression.saving_throw_bonus(:charisma)
        )
      end
    end
  end

  def append_equipment
    float do
      font_size 9
      bounding_box([396, from_top(100)], width: 140, height: 210) do
        @progression.equipment.each do |item|
          text item.dnd_equipment.name
        end
      end
    end
  end

  def append_features
    float do
      font_size 6
      bounding_box([14, from_top(465)], width: 360, height: 88) do
        @progression.dnd_features.each do |feature|
          text "#{feature.name}: #{feature.description}"
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
      bounding_box([396, from_top(390)], width: 140, height: 206) do
        @progression.dnd_spells.each do |spell|
          text spell.formatted_name
        end
        if @progression.dnd_spells.any? && @progression.dnd_cantrips.any?
          text "----------------------------------"
        end
        @progression.dnd_cantrips.each do |spell|
          text spell.name
        end
      end
    end
  end

  def append_avatar
    return unless avatar = @progression.character.avatar
    float do
      bounding_box([100, from_top(300)], width: 80, height: 130) do
        ###########data = StringIO.new(portrait.blob.download)
        # Can't figure out how to get the Variant (avatar_portrait)
        # from ActiveStorage. This might be a new feature coming
        # in Rails 6.1: "config.active_storage.track_variants"
        #
        # So we duplicate the processing here:
        variant = MiniMagick::Image.open helpers.url_for(avatar)
        variant.combine_options do |img|
          img.resize '480x480^'
          img.gravity 'center'
          img.extent '480x480'
          img.colorspace 'Gray'
        end
        image variant.path, width: 80
      end
    end
  end

private

  # bounding_box from BOTTOM-LEFT,
  # so make it easier to reason about
  def from_top(value)
    bounds.height - value
  end

  def pad(value)
    "%02d" % value
  end

  def helpers
    Rails.application.routes.url_helpers
  end
end
