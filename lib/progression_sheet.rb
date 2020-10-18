class ProgressionSheet < Prawn::Document
  def initialize(progression = Progression.new)
    super(
      :page_size => 'LETTER',
      :page_layout => :portrait,
      :compress => true
    )
    @progression = progression
    append_background
    font "Times-Roman"
    #text bounds.width.to_s (540)
    #text bounds.height.to_s (720)

    append_character_content
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
      # NAME
      bounding_box([15, from_top(17)], width: 150, height: 13) do
        font_size 13
        text @progression.character.name.truncate(24)
      end
      # RACE
      bounding_box([193, from_top(17)], width: 170, height: 13) do
        font_size 13
        text @progression.character.race
      end
      # SPEED
      bounding_box([388, from_top(17)], width: 50, height: 13) do
        font_size 13
        text @progression.character.speed.to_s
      end
      # LEVEL
      bounding_box([15, from_top(53)], width: 45, height: 13) do
        font_size 13
        text @progression.level.to_s
      end
      # Hitpoints MAX
      bounding_box([130, from_top(53)], width: 40, height: 13) do
        font_size 13
        text @progression.hit_points_max.to_s
      end
      # Class
      bounding_box([193, from_top(53)], width: 170, height: 13) do
        font_size 13
        text @progression.character.dnd_class
      end
      # Prof Bonus
      bounding_box([388, from_top(53)], width: 50, height: 13) do
        font_size 13
        text @progression.proficiency_bonus.to_s
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
        ## delete
        stroke_bounds
        ## /delete
      end
    end
  end

private

  # bounding_box from BOTTOM-LEFT,
  # so make it easier to reason about
  def from_top(value)
    bounds.height - value
  end

  def helpers
    Rails.application.routes.url_helpers
  end
end
