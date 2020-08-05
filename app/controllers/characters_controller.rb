class CharactersController < ApplicationController
  before_action :set_character,
    only: [:show, :edit, :update, :destroy, :edit_content_field]
  layout 'character', except: [:index, :new, :show]

  # GET /characters
  def index
    @characters = policy_scope(Character.all)
  end

  # GET /characters/new
  def new
    @character = Character.new
    authorize(@character)
  end

  def edit_content_field
    return redirect_to(
      character_path(@character)
    ) unless Character::RP_FIELDS.include?(params[:field]&.to_sym)
    @field = params[:field]
  end

  def create
    @character = Character.new(character_params)
    authorize(@character)
    @character.user = current_user
    return render :new unless @character.save
    redirect_to @character,
      notice: 'Character was successfully created.'
  end

  def update
    return render :show unless @character.update(character_params)
    redirect_to @character,
      notice: 'Character was successfully updated.'
  end

  def destroy
    @character.destroy
    respond_to do |format|
      format.html { redirect_to characters_url, notice: 'Character was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private
    # Use callbacks to share common setup or constraints between actions.
    def set_character
      @character = Character.find(params[:id])
      authorize(@character)
    end

    def character_params
      params.require(:character).
        permit(
          :name,
          :avatar,
          :dnd_class,
          :race,
          :background,
          :alignment,
          :appearance,
          :backstory,
          :personality,
          :ideals,
          :bonds,
          :flaws,
          :other_traits
        )
    end
end
