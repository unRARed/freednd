class ProgressionsController < ApplicationController
  before_action :set_progression,
    only: [:update, :edit_abilities, :edit_status]
  layout 'character'

  def edit_abilities
    @character = @progression.character
  end

  def edit_status
    @character = @progression.character
  end

  def update
    return render 'characters/show' unless @progression.
      update(progression_params)
    redirect_to @progression.character,
      notice: 'Progression was successfully updated.'
  end

private

  def set_progression
    @progression = Progression.find(params[:id])
    authorize(@progression)
  end

  def progression_params
    params.require(:progression).
      permit(
        :character_id,
        :party_id,
        #status
        :explicit_level,
        :experience,
        :hit_points,
        :hit_points_max,
        :inspiration,
        #abilities
        :archetype,
        :armor_class,
        :initiative,
        :speed,
        :strength,
        :strength_mod,
        :dexterity,
        :dexterity_mod,
        :constitution,
        :constitution_mod,
        :intelligence,
        :intelligence_mod,
        :wisdom,
        :wisdom_mod,
        :charisma,
        :charisma_mod
      )
  end
end
