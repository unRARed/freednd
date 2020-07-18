class ProgressionPolicy < ApplicationPolicy
  # DM and char owner can edit/update
  def update?
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

  def destroy_progression_item?
    edit?
  end

  def edit?
    user.present? && @record.user == user
  end
end
