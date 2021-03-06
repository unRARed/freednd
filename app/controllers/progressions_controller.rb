require 'progression_sheet'

class ProgressionsController < ApplicationController
  include CharactersHelper

  before_action :set_progression,
    except: [:destroy_progression_item]
  layout 'character'

  def show_for_print
    respond_to do |format|
      format.html do
        redirect_to character_path(@progression.character),
          flash: { danger: 'Wrong format requested.' }
      end
      format.pdf do
        pdf = ProgressionSheet.new(@progression)
        send_data pdf.render,
          filename: "#{@progression.character.name.\
            downcase.parameterize.strip}-#{Time.now.to_i}.pdf",
          type: 'application/pdf',
          disposition: 'inline'
      end
    end
  end

  def edit_abilities
  end

  def edit_status
  end

  def edit_wallet
  end

  def edit_spells
    @progression.spells.build
  end

  def edit_features
    @progression.features.build
  end

  def edit_equipment
    @progression.equipment.build
  end

  def update
    return render 'characters/show' unless @progression.
      update(progression_params)
    redirect_to @progression.character,
      notice: 'Progression was successfully updated.'
  end

  def update_wallet
    return render :edit_wallet unless @progression.
      change_wallet(wallet_params)
    redirect_to edit_campaign_progression_wallet_path,
      notice: 'Wallet was successfully updated.'
  end

  def destroy_progression_item
    @progression = Progression.find(params[:progression_id])
    authorize(@progression)
    progression_item = ProgressionItem.find(params[:id])
    record_type =
      if progression_item.dnd_spell
        'Spell'
      elsif progression_item.dnd_feature
        'Feature'
      elsif progression_item.dnd_equipment
        'Equipment'
      else
        'Progression Item'
      end
    progression_item.destroy!
    redirect_back(
      fallback_location: progression_path(@progression),
      notice: "#{record_type} was successfully removed."
    )
  end

  def roll_dice
    dice_roll = DiceRoll.create! query: params[:query],
      progression: @progression,
      campaign: @progression.campaign
    redirect_back(
      fallback_location: progression_path(@progression),
      notice: "You rolled #{dice_roll.query} and got #{dice_roll.result}."
    )
  end

private

  def set_progression
    @progression = Progression.find(params[:id])
    authorize(@progression)
  end

  def wallet_params
    params.permit(
      :platinum,
      :gold,
      :electrum,
      :silver,
      :copper
    )
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
        #rich text
        :inventory,
        skills_attributes: [ :id, :value, :is_proficient ],
        spells_attributes: [ :id, :dnd_spell_id ],
        features_attributes: [ :id, :dnd_feature_id ],
        equipment_attributes: [ :id, :dnd_equipment_id, :quantity ]
      )
  end
end
