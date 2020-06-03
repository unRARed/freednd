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

  def edit?
    user.present? && @record.user == user
  end
end
