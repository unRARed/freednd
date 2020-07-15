class ProgressionsController < ApplicationController
  before_action :set_progression
  layout 'character'

  def edit_abilities
  end

  def edit_status
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
        :charisma_mod,
        skills_attributes: [ :id, :value, :is_proficient ],
        saving_throws_attributes: [ :id, :value, :is_proficient ]
      )
  end
end
