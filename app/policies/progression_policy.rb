class ProgressionPolicy < ApplicationPolicy
  # DM and char owner can edit/update
  def update?
    edit?
  end

  def show_for_print?
    edit? || is_game_master?
  end

  def edit_inventory?
    edit?
  end

  def edit_wallet?
    edit?
  end

  def edit_abilities?
    edit?
  end

  def edit_status?
    edit?
  end

  def edit_skills?
    edit?
  end

  def edit_saving_throws?
    edit?
  end

  def edit_spells?
    edit?
  end

  def edit_features?
    edit?
  end

  def edit_equipment?
    edit?
  end

  def update_wallet?
    edit?
  end

  def destroy_progression_item?
    edit?
  end

  def roll_dice?
    edit?
  end

  def edit?
    user.present? && @record.user == user
  end

private

  def is_game_master?
    user.present? && @record.campaign.game_masters.
      any?{|gm| gm.user == user}
  end
end
