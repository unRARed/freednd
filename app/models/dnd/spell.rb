class DnD::Spell < ApplicationRecord
  scope :by_level, -> { order(:level => :asc) }

  def formatted_name
    return "Cantrip: #{self.name}" if self.level == 0
    "Lvl #{self.level}: #{self.name}"
  end

  def formatted_selection
    "#{self.formatted_name} (#{self.dnd_classes})"
  end
end
